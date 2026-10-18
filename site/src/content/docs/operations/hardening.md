---
title: Hardening
description: Every security control in the cluster, where it is set, and how strict it is.
sidebar:
  order: 3
---

## Nodes

Set by `ansible/roles/pre-setup`.

| Control | Setting |
|---|---|
| Kernel | `kptr_restrict=1`, `dmesg_restrict=1`, no ICMP redirects, no source routing, SYN cookies on |
| Kubelet requirements | `vm.overcommit_memory=1`, `kernel.panic=10`, `kernel.panic_on_oops=1` and the key limits, so `protectKernelDefaults` can be on |
| SELinux | permissive by default (`selinux_state`) |
| Packages | full `dnf update` only when `system_packages_upgrade: true` |
| SSH | Ansible verifies host keys (`host_key_checking = True`) |
| Downloads | Helm, Kustomize, ArgoCD CLI and HAProxy are checked against published SHA256 sums |

## Control plane

Set by `ansible/roles/kubeadm`. New clusters get it at `task cluster:init`. Existing clusters on 1.34 or later get it with `task cluster:harden`, which works through the control planes one at a time and never changes the Kubernetes version.

| Control | Setting |
|---|---|
| Audit log | `/var/log/kubernetes/audit/audit.log`, 30 days, 10 files of 100 MB |
| Secrets at rest | `secretbox` encryption. The key is created on the first control plane and copied only to the other control planes |
| Authentication | Keycloak OIDC through `AuthenticationConfiguration`. Anonymous access only on `/livez`, `/readyz`, `/healthz` and the `cluster-info` ConfigMap that `kubeadm join` reads |
| Profiling | off on the API server, controller manager and scheduler |
| TLS | 1.2 minimum on the API server and kubelets |
| Kubelet | read-only port off, anonymous auth off, webhook authorization, `RuntimeDefault` seccomp for every pod |
| Bootstrap tokens | deleted after the nodes join |

`task cluster:harden` also rewrites every existing Secret so it is stored encrypted, then reads one back from etcd to prove it.

:::note
Kubelet settings only apply to nodes that join after the change. Existing nodes keep their kubelet config until they are rejoined.
:::

## Workloads

| Control | Where | Mode |
|---|---|---|
| Pod Security Admission | `managedNamespaceMetadata` on each Application | enforced |
| Kyverno restricted profile | `kyverno-policies` app | audit only, see `kubectl get polr -A` |
| NetworkPolicies | `argocd`, `keycloak`, `logging`, `headlamp` | ingress allow-lists |

Pod Security levels per namespace:

| Level | Namespaces | Why not stricter |
|---|---|---|
| `restricted` | `cert-manager`, `headlamp` | |
| `baseline` (warn on `restricted`) | `envoy-gateway-system`, `keycloak`, `cnpg-system`, `external-secrets`, `kyverno` | upstream charts are not fully restricted-ready |
| `privileged` | `kube-system`, `longhorn-system`, `monitoring`, `logging`, `metallb`, `netbird` | host networking, host paths or `NET_ADMIN` |

## Edge

| Control | Setting |
|---|---|
| TLS | 1.2 minimum, HTTP redirects to HTTPS |
| Headers | HSTS (1 year, subdomains), `nosniff`, `strict-origin-when-cross-origin`; `Server` and `X-Powered-By` removed |
| Slow clients | 30 seconds to send a request, 5 minutes idle |
| Listener isolation | each hostname only accepts routes from its own namespace |
| Login | every UI requires Keycloak, with TOTP |

## Secrets

- No secret is committed. The only one created by hand is the Vault token for External Secrets.
- The ArgoCD admin password and the keepalived password are random and stay in `.secrets/` on your workstation (gitignored).
- `argocd-initial-admin-secret` is deleted after bootstrap.

## Known gaps

- Kyverno only reports violations. Move single policies to `Enforce` with `validationFailureActionByPolicy` once their reports are clean.
- There is no default-deny NetworkPolicy. Namespaces without an allow-list accept traffic from any pod.
- SELinux is permissive.
- AppProjects allow any source repository and destination.
