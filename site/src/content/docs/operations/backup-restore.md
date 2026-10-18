---
title: Backup and restore
description: What is backed up, where, and how to get it back.
sidebar:
  order: 4
---

## What is covered

| Data | How | Where |
|---|---|---|
| Volumes on `longhorn` and `longhorn-crypto` | Longhorn backup, daily, 14 kept | S3 bucket `kubegoros-backups` |
| All Longhorn volumes | snapshots, hourly, 24 kept | on the cluster |
| Cluster configuration | git | this repository |
| Secrets | Vault | outside the cluster |
| etcd | not automated | take a snapshot before every upgrade |

## Restore one volume

1. Scale the workload that uses the volume to zero.
2. In the Longhorn UI, open Backup, pick the volume and the backup, and choose Restore. Give it a new name.
3. Once the restored volume is healthy, use Create PV/PVC on it with the original PVC name and namespace. Delete the old PVC first.
4. Scale the workload back up.

To roll back in place instead, use a snapshot: open the volume, pick a snapshot, Revert. The volume must be detached first.

## Rebuild the cluster from nothing

1. Build the nodes and run `task cluster:init` ([Build the cluster](/kubegoros/getting-started/bootstrap/)).
2. Create the `vault-token` secret. ArgoCD reinstalls every app.
3. Longhorn reconnects to the S3 target and lists the old backups. Restore the volumes as above, starting with `keycloak-db`, then Loki, Grafana and Prometheus if you want their history.

Encrypted backups need the same `longhorn-crypto` passphrase in Vault as when they were taken.

## etcd snapshot

```bash
sudo ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /var/backups/etcd-$(date +%F).db
```

Copy the file off the node. With encryption at rest on, the snapshot is only useful together with `/etc/kubernetes/encryption/` from a control plane.
