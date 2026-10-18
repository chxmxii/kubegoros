---
title: Overview
description: The three layers of the cluster and who owns each one.
sidebar:
  order: 1
---

kubegoros has three layers, each managed by one tool.

| Layer | Owned by | Lives in |
|---|---|---|
| Machines: OS packages, kernel settings, containerd, kubeadm, API server flags | Ansible | `ansible/` |
| Bootstrap: Cilium, ArgoCD and the root Application | Ansible, once | `ansible/roles/kubeadm`, `ansible/roles/gitops` |
| Everything else | ArgoCD | `kubernetes/apps/` |

## Machines

Six VMs on Proxmox: three control planes and three workers, running EL8 or EL9 (Rocky, Alma or RHEL). Two LXC containers run HAProxy and keepalived, which publish the API server on the virtual IP `10.254.100.99:6443`.

The roles do not support Fedora CoreOS. The OpenTofu code in `proxmox/opentofu` still builds CoreOS images, so use EL templates for cluster nodes.

## Bootstrap

`task cluster:init` runs `ansible/playbooks/cluster.yml`. On the first control plane it:

1. runs `kubeadm init` with kube-proxy skipped,
2. installs Cilium from `kubernetes/apps/networking/cilium/chart`, the same chart ArgoCD manages later,
3. installs ArgoCD and applies the `root-app` Application.

After that, ArgoCD manages Cilium like any other app.

## Apps

`root-app` picks up every `*.app.yaml` under `kubernetes/apps`. Each file is one ArgoCD Application that points at a wrapper Helm chart, a kustomization or a plain directory next to it.

| Path | Applications |
|---|---|
| `networking/` | cilium, metallb, envoy-gateway, edge, netbird |
| `security/` | cert-manager, external-secrets, kyverno, kyverno-policies, keycloak, headlamp, cluster-rbac |
| `storage/` | longhorn, cloudnative-pg |
| `monitoring/` | kube-prometheus-stack, metrics-server |
| `logging/` | loki, vector |
| `miscs/` | argocd-config |

Sync waves order the first install: Cilium (`-10`), Envoy Gateway and the Gateway API CRDs (`-5`), CloudNativePG and External Secrets (`-1`), then the rest. A health check in `argocd-cm` makes ArgoCD wait until each wave's Applications are Healthy before it starts the next wave.
