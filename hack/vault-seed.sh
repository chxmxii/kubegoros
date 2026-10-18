#!/usr/bin/env bash
# Seed the Vault secrets the cluster reads through External Secrets (KV v1 mount "secret").
# Existing paths are left alone, so it is safe to re-run. Needs VAULT_ADDR and VAULT_TOKEN.
#
#   secret/keycloak-clients  argocd, grafana, headlamp, edge-proxy   (random, generated here)
#   secret/longhorn-crypto   passphrase                              (random, generated here; BACK IT UP)
#   secret/longhorn-backup   AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_ENDPOINTS (prompted)
#   secret/netbird           api_key                                 (prompted)
set -euo pipefail

: "${VAULT_ADDR:?set VAULT_ADDR}"
: "${VAULT_TOKEN:?set VAULT_TOKEN}"
MOUNT=${VAULT_MOUNT:-secret}

rand() { openssl rand -hex "$(( ${1:-40} / 2 ))"; }
exists() { vault kv get -mount="$MOUNT" "$1" >/dev/null 2>&1; }

if exists keycloak-clients; then
  echo "keycloak-clients: exists, skipping"
else
  vault kv put -mount="$MOUNT" keycloak-clients \
    argocd="$(rand)" grafana="$(rand)" headlamp="$(rand)" edge-proxy="$(rand)"
  echo "keycloak-clients: created"
fi

if exists longhorn-crypto; then
  echo "longhorn-crypto: exists, skipping"
else
  vault kv put -mount="$MOUNT" longhorn-crypto passphrase="$(rand 64)"
  echo "longhorn-crypto: created. Store a copy of this passphrase outside the cluster:"
  echo "  vault kv get -mount=$MOUNT -field=passphrase longhorn-crypto"
fi

if exists longhorn-backup; then
  echo "longhorn-backup: exists, skipping"
else
  read -rp "S3 access key id: " ak
  read -rsp "S3 secret access key: " sk; echo
  read -rp "S3 endpoint URL (empty for AWS): " ep
  args=(AWS_ACCESS_KEY_ID="$ak" AWS_SECRET_ACCESS_KEY="$sk")
  [[ -n "$ep" ]] && args+=(AWS_ENDPOINTS="$ep")
  vault kv put -mount="$MOUNT" longhorn-backup "${args[@]}"
  echo "longhorn-backup: created"
fi

if exists netbird; then
  echo "netbird: exists, skipping"
else
  read -rsp "NetBird service-user access token: " nb; echo
  vault kv put -mount="$MOUNT" netbird api_key="$nb"
  echo "netbird: created"
fi
