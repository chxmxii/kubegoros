# Migrating the running cluster from Calico to Cilium

New clusters get Cilium (with kube-proxy replacement) straight from `task cluster:init`.
For the **existing** cluster you have two options.

## Option A: rebuild (simplest)

ArgoCD reconciles every app from git, and Longhorn volumes can be backed up and restored. So for a homelab, the
cleanest path is `task cluster:reset` → `task cluster:init` once the cluster is on ≥ 1.33.

## Option B: in-place, node by node

This follows the upstream guide: <https://docs.cilium.io/en/stable/installation/k8s-install-migration/>.
Cilium runs alongside Calico on a **separate pod CIDR and VXLAN port** until every node is moved.
Requirements: cluster on Kubernetes ≥ 1.33, `helm` and `cilium` CLI on your workstation.

```bash
# 0. Pause ArgoCD auto-sync for cilium (it would apply the final config too early)
kubectl -n argocd patch app cilium --type merge -p '{"spec":{"syncPolicy":{"automated":null}}}'

# 1. Install Cilium in migration mode: no CNI ownership, its own CIDR and VXLAN port
helm repo add cilium https://helm.cilium.io
helm install cilium cilium/cilium --version 1.20.3 -n kube-system \
  --set operator.unmanagedPodWatcher.restart=false \
  --set cni.customConf=true \
  --set policyEnforcementMode=never \
  --set bpf.hostLegacyRouting=true \
  --set ipam.mode=cluster-pool \
  --set ipam.operator.clusterPoolIPv4PodCIDRList=10.245.0.0/16 \
  --set tunnelPort=8473 \
  --set routingMode=tunnel --set tunnelProtocol=vxlan
cilium status --wait

# 2. Per-node CNI switch config
cat <<'YAML' | kubectl apply -f -
apiVersion: cilium.io/v2
kind: CiliumNodeConfig
metadata:
  namespace: kube-system
  name: cilium-default
spec:
  nodeSelector:
    matchLabels:
      io.cilium.migration/cilium-default: "true"
  defaults:
    write-cni-conf-when-ready: /host/etc/cni/net.d/05-cilium.conflist
    custom-cni-conf: "false"
    cni-chaining-mode: "none"
    cni-exclusive: "true"
YAML

# 3. For EACH node (workers first, then control planes):
NODE=workernode01
kubectl cordon $NODE
kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data
kubectl label node $NODE --overwrite "io.cilium.migration/cilium-default=true"
kubectl -n kube-system delete pod --field-selector spec.nodeName=$NODE -l k8s-app=cilium
kubectl -n kube-system rollout status ds/cilium -w
ssh $NODE sudo reboot              # clears Calico's interfaces and routes
cilium status --wait
kubectl uncordon $NODE
# check that pods scheduled on $NODE can reach pods on unmigrated nodes before continuing

# 4. Once every node is migrated: remove Calico
kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/<version-you-installed>/manifests/calico.yaml
# on every node: sudo rm -f /etc/cni/net.d/10-calico.conflist /etc/cni/net.d/calico-kubeconfig

# 5. Switch to the final config from git (kube-proxy replacement, ipam=kubernetes, VXLAN 8472).
#    Changing the IPAM mode means every pod needs a new IP, so roll the nodes one more time.
kubectl -n argocd patch app cilium --type merge -p '{"spec":{"syncPolicy":{"automated":{"selfHeal":true}}}}'
kubectl -n argocd get app cilium -w     # wait for Synced/Healthy
kubectl delete ciliumnodeconfig -n kube-system cilium-default
#    then for each node: drain → reboot → uncordon

# 6. Remove kube-proxy (DaemonSet AND ConfigMap, so kubeadm upgrades don't reinstall it)
kubectl -n kube-system delete ds kube-proxy
kubectl -n kube-system delete cm kube-proxy
# on every node: sudo iptables-save | grep -v KUBE | sudo iptables-restore
cilium status && cilium connectivity test
```
