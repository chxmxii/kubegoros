This directory contains the Kubernetes apps deployed by ArgoCD. The `root-app` (bootstrapped by
`ansible/roles/gitops`) picks up every `*.app.yaml` under `apps/`:

| Path | Apps |
|---|---|
| `apps/networking` | Cilium, MetalLB, Envoy Gateway, edge (Gateway, routes, SSO), NetBird |
| `apps/security` | cert-manager, external-secrets, Kyverno, kyverno-policies, Keycloak, Headlamp, cluster-rbac |
| `apps/storage` | Longhorn, CloudNativePG |
| `apps/monitoring` | kube-prometheus-stack, metrics-server |
| `apps/logging` | Loki, Vector |
| `apps/miscs` | ArgoCD config |

See the [documentation](https://chxmxii.github.io/kubegoros/) for the one-time setup (Vault, NetBird, Keycloak).
