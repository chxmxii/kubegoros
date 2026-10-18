This directory contains the Kubernetes apps deployed by ArgoCD. The `root-app` (bootstrapped by
`ansible/roles/gitops`) picks up every `*.app.yaml` under `apps/`:

| Path | Apps |
|---|---|
| `apps/networking` | Cilium, MetalLB, ingress-nginx, NetBird |
| `apps/security` | cert-manager, external-secrets, Kyverno, Keycloak |
| `apps/storage` | Longhorn, CloudNativePG |
| `apps/monitoring` | kube-prometheus-stack, metrics-server |
| `apps/logging` | Loki, Vector |
| `apps/miscs` | ArgoCD config |

See [docs/platform.md](../docs/platform.md) for the one-time setup (Vault token, NetBird, Keycloak admin).
