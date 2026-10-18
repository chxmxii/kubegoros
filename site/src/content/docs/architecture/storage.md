---
title: Storage
description: Longhorn volumes, storage classes, snapshots, S3 backups and encryption.
sidebar:
  order: 4
---

Longhorn provides block storage on the three workers. Its UI is at `https://longhorn.lab.chxmxii.xyz`, behind gateway SSO.

## Storage classes

| Class | Replicas | Snapshots | S3 backups | Encrypted | Use for |
|---|---|---|---|---|---|
| `longhorn` (default) | 2 | hourly, kept 24 | daily, kept 14 | no | most things |
| `longhorn-no-backups` | 2 | hourly, kept 24 | none | no | caches, data you can rebuild |
| `longhorn-crypto` | 2 | hourly, kept 24 | daily, kept 14 | LUKS | credentials, personal data |

Two replicas on three workers survive one node failure and leave a third node free to rebuild on. Replicas of the same volume never share a node.

## What uses it

| Workload | Class | Size |
|---|---|---|
| Prometheus | `longhorn` | 20Gi, 15 days or 18GB retention |
| Alertmanager | `longhorn` | 2Gi |
| Grafana | `longhorn` | 5Gi |
| Loki | `longhorn` | 30Gi, 30 days retention |
| Keycloak database (CNPG, 2 instances) | `longhorn` | 5Gi each |

## Recurring jobs

Volumes join a recurring-job group through their storage class. Volumes without one are in `default`.

| Job | Schedule | Groups |
|---|---|---|
| `snapshot-hourly` | minute 15 every hour, keep 24 | `default`, `no-backup` |
| `backup-daily` | 02:30, keep 14 | `default` |
| `trim-weekly` | Saturday 04:00 | `default`, `no-backup` |

Snapshot integrity is checked every Sunday at 03:00 with `fast-check`.

## Backups

Backups go to `s3://kubegoros-backups@eu-central-2/longhorn`. Change the bucket and region in `kubernetes/apps/storage/longhorn/chart/values.yaml` (both `backup.target` and `longhorn.defaultBackupStore.backupTarget`). Credentials come from Vault at `secret/longhorn-backup`:

| Key | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | access key |
| `AWS_SECRET_ACCESS_KEY` | secret key |
| `AWS_ENDPOINTS` | endpoint URL, for anything that is not AWS (Wasabi, MinIO, B2) |

Restoring is covered in [Backup and restore](/kubegoros/operations/backup-restore/).

## Encryption

`longhorn-crypto` volumes are LUKS-encrypted on the node with one passphrase from Vault (`secret/longhorn-crypto`, key `passphrase`). Backups of these volumes stay encrypted.

:::danger
If the passphrase is lost, every `longhorn-crypto` volume and every backup of one is unreadable. Keep a copy outside the cluster and outside Vault.
:::

## Node drains

`nodeDrainPolicy` is `block-for-eviction-if-contains-last-replica`. A drain waits while a node holds the only healthy replica of a volume, so the upgrade playbook cannot take the last copy of your data offline.
