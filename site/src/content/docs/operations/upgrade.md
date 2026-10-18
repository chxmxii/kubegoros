---
title: Upgrade Kubernetes
description: Move the cluster up one minor version at a time.
sidebar:
  order: 1
---

`ansible/playbooks/upgrade.yml` upgrades the cluster by one minor version per run, because kubeadm cannot skip minor versions. For each node, one at a time (the initial control plane first, then the other control planes, then the workers), it:

1. points the `pkgs.k8s.io` repo at the target minor and upgrades `kubeadm`
2. runs `kubeadm upgrade apply` (initial control plane) or `kubeadm upgrade node`
3. drains the node, upgrades containerd, `kubelet` and `kubectl`, restarts kubelet
4. waits for the node to report the new version and `Ready`, then uncordons it

```bash
task cluster:upgrade VERSION=1.30
```

Before each step, take an etcd snapshot and check that every Longhorn volume is healthy. A volume without a replica on another node blocks the drain.

## Path from 1.29 to 1.37

Cilium 1.20 requires Kubernetes 1.33 or later, and the Calico version on the cluster was never pinned, so the CNI switch happens at 1.33:

| Step | Command / action | Notes |
|---|---|---|
| 1 | `VERSION=1.30` | |
| 2 | `VERSION=1.31` | kubeadm migrates its stored config to `v1beta4` |
| 3 | `VERSION=1.32` | |
| 4 | `VERSION=1.33` | |
| 5 | Calico to Cilium | see [Calico to Cilium](/kubegoros/operations/cilium-migration/) |
| 6 | `VERSION=1.34` | Longhorn 1.13+ needs 1.34 or later |
| 7 | `task cluster:harden` | audit logging, encryption at rest, Keycloak OIDC, see [Hardening](/kubegoros/operations/hardening/) |
| 8 | `VERSION=1.35` | cgroup v2 required, the playbook checks it (see below) |
| 9 | `VERSION=1.36` | containerd 2.x required, the playbook upgrades `containerd.io` |
| 10 | `VERSION=1.37` | Cilium 1.20 is officially tested up to 1.36; check the Cilium compatibility matrix first |

After each step, run `task cluster:verify` and check that `kubectl get nodes` and every ArgoCD application are Healthy before moving on.

### cgroup v2 (1.35+)

From 1.35 on, kubelet refuses to start on cgroup v1 hosts. EL8 boots cgroup v1 by default:

```bash
grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=1" && reboot
stat -fc %T /sys/fs/cgroup   # must print cgroup2fs
```

### kube-proxy

After the Cilium migration there is no kube-proxy. kubeadm upgrades the kube-proxy addon only when the `kube-system/kube-proxy` ConfigMap exists, so delete both the DaemonSet and the ConfigMap (the migration runbook does this). Otherwise `kubeadm upgrade apply` installs kube-proxy again.
