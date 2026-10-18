---
title: Calico to Cilium
description: Move an existing Calico cluster to Cilium, by rebuilding or node by node.
sidebar:
  order: 2
---

New clusters get Cilium (with kube-proxy replacement) straight from `task cluster:init`.
An existing Calico cluster can be moved in two ways.

## Option A: rebuild

Every app is redeployed from git and Longhorn volumes can be restored from S3, so rebuilding with `task cluster:reset` and `task cluster:init` is the least work.

## Option B: in-place, node by node

This follows the upstream guide: <https://docs.cilium.io/en/stable/installation/k8s-install-migration/>.
Cilium runs alongside Calico, on a separate pod CIDR and VXLAN port, until every node is moved.
Requirements: Kubernetes 1.33 or later, and the `helm` and `cilium` CLIs on your workstation.

Do this while `root-app` still tracks the old repository (see [Rolling out on the running cluster](/kubegoros/operations/rollout/)), so ArgoCD does not apply the final Cilium config halfway through.

```bash
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

# 5. Switch to the final config from git (kube-proxy replacement, ipam=kubernetes, VXLAN 8472)
#    by pointing root-app at this repository (rollout step 4). ArgoCD creates the cilium app
#    and applies the final values. Changing the IPAM mode means every pod needs a new IP,
#    so roll the nodes one more time.
kubectl -n argocd get app cilium -w     # wait for Synced/Healthy
kubectl delete ciliumnodeconfig -n kube-system cilium-default
#    then for each node: drain, reboot, uncordon

# 6. Remove kube-proxy (DaemonSet AND ConfigMap, so kubeadm upgrades don't reinstall it)
kubectl -n kube-system delete ds kube-proxy
kubectl -n kube-system delete cm kube-proxy
# on every node: sudo iptables-save | grep -v KUBE | sudo iptables-restore
cilium status && cilium connectivity test
```
