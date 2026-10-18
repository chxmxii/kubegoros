---
title: Secrets and first-time setup
description: What has to exist in Vault and NetBird before ArgoCD can sync everything.
sidebar:
  order: 2
---

No secrets are stored in git. Credentials are stored in Vault (KV version 1, mount `secret`) and is copied into the cluster by External Secrets through the `vault` ClusterSecretStore.

## Seed Vault

```bash
export VAULT_ADDR=http://10.254.100.107:8200
export VAULT_TOKEN=...
hack/vault-seed.sh
```

The script never overwrites an existing path, so it is safe to run again.

| Path | Keys | Source |
|---|---|---|
| `secret/keycloak-clients` | `argocd`, `grafana`, `headlamp`, `edge-proxy` | generated |
| `secret/longhorn-crypto` | `passphrase` | generated, back it up |
| `secret/longhorn-backup` | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_ENDPOINTS` | prompted |
| `secret/netbird` | `api_key` | prompted |

## Give External Secrets its token

External Secrets needs a Vault token to read those paths. Create it by hand once. It is the only secret created outside git or Vault:

```bash
kubectl create namespace external-secrets
kubectl -n external-secrets create secret generic vault-token --from-literal=token=<token>
```

Use a token restricted to read on `secret/*`, not a root token.

## NetBird

1. In the NetBird dashboard, create a service user and a personal access token for it. That token is the `api_key` the seed script asks for.
2. Create the DNS zone `lab.chxmxii.xyz` (DNS, Zones).
3. Create the group `homelab-admins` and add your laptop and phone peers to it.
4. Add an access policy that lets `homelab-admins` reach the `kubegoros` network.

For a self-hosted NetBird, also set `kubernetes-operator.managementURL` in `kubernetes/apps/networking/netbird/chart/values.yaml`.
