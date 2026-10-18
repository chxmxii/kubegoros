---
title: Rolling out on the running cluster
description: The order for moving the existing 1.29 Calico cluster to the current repository.
sidebar:
  order: 0
---

The running cluster's `root-app` still points at the old GitLab repository. Merging to this repository therefore changes nothing on the cluster until you repoint `root-app`. That is on purpose: the apps here assume Kubernetes 1.34 or later, Cilium and Envoy Gateway. Applying them to a 1.29 cluster on Calico with ingress-nginx would cut its network and every UI.

Follow this order.

| Step | What | Where |
|---|---|---|
| 1 | Replace the CentOS 7 load balancers with EL8 or EL9, rerun `--tags haproxy` | [Build the cluster](/kubegoros/getting-started/bootstrap/) |
| 2 | Upgrade 1.29 to 1.33, one minor at a time | [Upgrade Kubernetes](/kubegoros/operations/upgrade/) |
| 3 | Migrate Calico to Cilium, steps 1 to 4 | [Calico to Cilium](/kubegoros/operations/cilium-migration/) |
| 4 | Seed Vault and create the `vault-token` secret | [Secrets and first-time setup](/kubegoros/getting-started/secrets/) |
| 5 | Upgrade ArgoCD to 3.5 (below) | |
| 6 | Point `root-app` at this repository (below) | |
| 7 | Finish the Cilium migration, steps 5 and 6 | [Calico to Cilium](/kubegoros/operations/cilium-migration/) |
| 8 | Upgrade to 1.34, run `task cluster:harden`, then continue to 1.37 | [Upgrade Kubernetes](/kubegoros/operations/upgrade/) |

## Upgrade ArgoCD

ArgoCD is installed by Ansible, not managed by itself, so a version bump in git only affects new clusters. The running cluster is on 2.10. Read the [2.x to 3.x upgrade notes](https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/overview/) first, then:

```bash
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.5/manifests/install.yaml
```

## Repoint root-app

```bash
kubectl -n argocd patch application root-app --type merge -p \
  '{"spec":{"source":{"repoURL":"https://github.com/chxmxii/kubegoros.git"}}}'
kubectl -n argocd get applications -w
```

ArgoCD then:

- creates the new apps (Envoy Gateway, edge, Keycloak, Headlamp, CloudNativePG, Vector, kyverno-policies, cluster-rbac, NetBird),
- moves Loki from `monitoring` to `logging`,
- deletes ingress-nginx. All UIs move to the edge gateway at `10.254.100.205`, so update DNS before this step.

ArgoCD reads `server.insecure` only at startup. Restart it once after the switch so it serves plain HTTP behind the gateway:

```bash
kubectl -n argocd rollout restart deployment argocd-server
```

Until Keycloak is up and your user exists, sign in to ArgoCD with `admin` and the password in `.secrets/argocd-admin-password`. If the cluster was built before this change, that file does not exist yet. Set a new password with `argocd account update-password` and store it there.
