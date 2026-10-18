---
title: First login
description: Create your Keycloak user and check every UI.
sidebar:
  order: 4
---

## 1. Keycloak admin

The operator creates a temporary admin account in the `master` realm:

```bash
kubectl -n keycloak get secret keycloak-initial-admin -o jsonpath='{.data.username}' | base64 -d; echo
kubectl -n keycloak get secret keycloak-initial-admin -o jsonpath='{.data.password}' | base64 -d; echo
```

Sign in at `https://keycloak.lab.chxmxii.xyz/admin`, create a permanent admin for the `master` realm, and delete the temporary one.

## 2. Your user

In the `kubegoros` realm:

1. Users, Add user. Set username and email, and mark the email as verified.
2. Credentials, Set password, with Temporary on.
3. Groups, Join group, `k8s-admins`.

At your first login Keycloak asks for a new password and a TOTP authenticator.

## 3. Try every door

| URL | Expect |
|---|---|
| `https://argocd.lab.chxmxii.xyz` | "Log in via Keycloak", admin rights |
| `https://grafana.lab.chxmxii.xyz` | straight to Keycloak, Admin role |
| `https://headlamp.lab.chxmxii.xyz` | sign in, full cluster view |
| `https://prometheus.lab.chxmxii.xyz` | Keycloak login, then Prometheus |
| `https://longhorn.lab.chxmxii.xyz` | Keycloak login, then Longhorn |
| `kubectl --context lab get nodes` | browser opens once, then nodes |

A user who is only in `k8s-viewers` gets read-only ArgoCD, Grafana Viewer, the `view` role in Kubernetes, and a 403 from the four gateway-protected UIs.

The kubectl context is set up in [Identity and SSO](/kubegoros/architecture/identity/#using-kubectl).
