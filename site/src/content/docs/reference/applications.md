---
title: Applications
description: Every ArgoCD Application, its namespace, chart version and sync wave.
---

Taken from the `*.app.yaml` files under `kubernetes/apps`, in sync order. Renovate bumps the chart versions.

| Wave | Application | Namespace | Source | Path |
|---|---|---|---|---|
| -10 | cilium | `kube-system` | `cilium` 1.20.3 | `kubernetes/apps/networking/cilium` |
| -5 | envoy-gateway | `envoy-gateway-system` | `gateway-helm` v1.9.2 | `kubernetes/apps/networking/envoy-gateway` |
| -1 | cloudnative-pg | `cnpg-system` | `cloudnative-pg` 0.29.1 | `kubernetes/apps/storage/cloudnative-pg` |
| -1 | external-secrets | `external-secrets` | `external-secrets` 1.3.2 | `kubernetes/apps/security/external-secrets` |
| 0 | argocd-config | `argocd` | manifests | `kubernetes/apps/miscs/argocd` |
| 0 | cert-manager | `cert-manager` | `cert-manager` v1.21.1 | `kubernetes/apps/security/cert-manager` |
| 0 | cluster-rbac | `cluster-wide` | manifests | `kubernetes/apps/security/cluster-rbac` |
| 0 | edge | `envoy-gateway-system` | kustomization | `kubernetes/apps/networking/edge` |
| 0 | headlamp | `headlamp` | `headlamp` 0.46.0 | `kubernetes/apps/security/headlamp` |
| 0 | keycloak | `keycloak` | kustomization | `kubernetes/apps/security/keycloak` |
| 0 | kube-prometheus-stack | `monitoring` | kustomization | `kubernetes/apps/monitoring/kube-prometheus-stack` |
| 0 | kyverno | `kyverno` | `kyverno` 3.8.2 | `kubernetes/apps/security/kyverno` |
| 0 | kyverno-policies | `kyverno` | `kyverno-policies` 3.8.2 | `kubernetes/apps/security/kyverno-policies` |
| 0 | loki | `logging` | `loki` 18.17.1 | `kubernetes/apps/logging/loki` |
| 0 | longhorn | `longhorn-system` | `longhorn` 1.12.0 | `kubernetes/apps/storage/longhorn` |
| 0 | metallb | `metallb` | `metallb` 0.16.1 | `kubernetes/apps/networking/metallb` |
| 0 | metric-server | `kube-system` | `metrics-server` 3.13.1 | `kubernetes/apps/monitoring/metric-server` |
| 0 | netbird | `netbird` | `kubernetes-operator` 0.3.1 | `kubernetes/apps/networking/netbird` |
| 0 | vector | `logging` | `vector` 0.59.0 | `kubernetes/apps/logging/vector` |
