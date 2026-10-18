# Platform apps: one-time setup

Everything below is deployed by ArgoCD from `kubernetes/apps`. These are the things git can't hold.

## External Secrets → Vault

The Vault token is no longer committed. Create it before ESO syncs:

```bash
kubectl create ns external-secrets
kubectl -n external-secrets create secret generic vault-token --from-literal=token=<vault-token>
```

## Logging (Loki + Vector)

- **Loki** (`logging` ns): single binary, filesystem storage on a 30Gi Longhorn PVC, 30-day retention.
  It is only reachable in-cluster at `http://loki-gateway.logging.svc`.
- **Vector** (`logging` ns): DaemonSet that ships every container log to Loki with the labels
  `namespace`, `app`, `container`, `node` and `stream` (the pod name goes into structured metadata).
- **Grafana** already has a `Loki` datasource. Try: `{namespace="argocd"} |= "error"`.

## Keycloak

- The Keycloak Operator 26.8.1 and a 2-instance CloudNativePG cluster (`keycloak-db`) run in the `keycloak` ns.
- The UI is at <https://keycloak.k8s.coralio.co>. Get the bootstrap admin with:
  ```bash
  kubectl -n keycloak get secret keycloak-initial-admin -o jsonpath='{.data.username}' | base64 -d; echo
  kubectl -n keycloak get secret keycloak-initial-admin -o jsonpath='{.data.password}' | base64 -d; echo
  ```
  Create a permanent admin user, then delete the temporary one.

## NetBird tunnel

The NetBird operator (`netbird` ns) runs two routing peers. It publishes cluster services as NetBird
network resources, so peers in the allowed groups can reach them from anywhere without
opening ports.

1. In the NetBird dashboard, create a service user with a Personal Access Token and store the token in Vault:
   `vault kv put secret/netbird api_key=<token>`
2. Create the DNS zone `k8s.coralio.co` (Dashboard → DNS → Zones) and the group `homelab-admins`. Add your peers to the group.
3. Add an access policy that allows `homelab-admins` to reach the `kubegoros` network.
4. Change which services are exposed under `resources:` in `kubernetes/apps/networking/netbird/chart/values.yaml`.
   By default only `ingress-nginx-controller` is exposed, which carries every Ingress host.

For self-hosted NetBird, set `kubernetes-operator.managementURL` in the chart values.
