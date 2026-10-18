---
title: Build the cluster
description: From empty VMs to a cluster that ArgoCD manages.
sidebar:
  order: 3
---

## 1. Inventory

Hosts are listed in `inventory.yml` and configured in `ansible/playbooks/host_vars/`. Exactly one control plane has `kube_cluster_initial_controlplane: true`; it runs `kubeadm init` and every cluster-wide command.

```bash
task nodes:check   # ping every host
task nodes:list    # show the inventory tree
```

## 2. Load balancers

```bash
ansible-playbook ansible/playbooks/cluster.yml --tags haproxy
```

This builds HAProxy from a checksummed release tarball, sets up keepalived for the `10.254.100.99` VIP, and exposes metrics for Prometheus. The keepalived password is generated into `.secrets/` on your workstation.

## 3. Cluster

```bash
task cluster:init
```

On every node: Python 3.11, kernel modules and sysctls, Longhorn prerequisites (iSCSI, NFS, cryptsetup), containerd with the systemd cgroup driver, and kubeadm, kubelet and kubectl from `pkgs.k8s.io`.

On the first control plane, `kubeadm init` starts Kubernetes 1.37 with:

- audit logging to `/var/log/kubernetes/audit/`,
- Secrets encrypted at rest with a key that never leaves the control planes,
- Keycloak as an OIDC issuer, and anonymous access limited to health checks,
- no kube-proxy.

It then installs Cilium and ArgoCD and applies `root-app`. The other control planes and the workers join after that.

The ArgoCD `admin` password is random and written to `.secrets/argocd-admin-password`. Use it when Keycloak is unavailable.

## 4. Watch ArgoCD sync

```bash
kubectl -n argocd get applications -w
```

The first sync is slow: each wave waits for the previous one to be Healthy, and certificates need DNS and port 80 in place. Apps that need Vault secrets stay Degraded until [the secrets exist](/kubegoros/getting-started/secrets/).

## 5. Check it

```bash
task cluster:verify
```

This read-only playbook checks that every node is Ready, Cilium is healthy, kube-system pods are running, anonymous requests are refused, and lists any ArgoCD Application that is not Synced and Healthy.

Then [sign in for the first time](/kubegoros/getting-started/first-login/).
