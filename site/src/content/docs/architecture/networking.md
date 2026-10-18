---
title: Networking
description: Cilium, MetalLB, Envoy Gateway, cert-manager and NetBird.
sidebar:
  order: 2
---

## Pod network: Cilium

Cilium is the CNI and replaces kube-proxy. kubeadm is told to skip the kube-proxy addon, and Cilium reaches the API server through the VIP rather than the `kubernetes` Service, which does not work without kube-proxy.

| Setting | Value | Why |
|---|---|---|
| `kubeProxyReplacement` | `true` | Services are handled in eBPF |
| `k8sServiceHost` | `10.254.100.99` | API VIP, reachable before any Service works |
| `ipam.mode` | `kubernetes` | Uses the per-node pod CIDRs from `10.244.0.0/16` |
| `routingMode` | `tunnel` (VXLAN, UDP 8472) | Works on any L2 network |
| `hubble.tls.auto.method` | `cronJob` | Keeps generated certificates out of git diffs |

The ArgoCD Application for Cilium never prunes and has no deletion finalizer. Deleting it by mistake leaves the CNI running.

## Addresses: MetalLB

MetalLB announces LoadBalancer addresses over L2 from two pools:

- `block-a`: `10.254.100.205` to `10.254.100.215`
- `block-b`: `10.254.100.70` to `10.254.100.85`

The edge gateway always takes `10.254.100.205`. Point your DNS records there.

## HTTPS: Envoy Gateway

All web traffic enters through one Gateway API `Gateway` called `edge` in `envoy-gateway-system`. It has an HTTP listener that redirects to HTTPS, and one HTTPS listener per hostname. Each listener only accepts routes from the namespace that owns that app.

| Hostname | Backend | Login |
|---|---|---|
| `argocd.lab.chxmxii.xyz` | `argocd/argocd-server` | ArgoCD OIDC |
| `grafana.lab.chxmxii.xyz` | `monitoring/kube-prometheus-stack-grafana` | Grafana OAuth |
| `headlamp.lab.chxmxii.xyz` | `headlamp/headlamp` | Headlamp OIDC |
| `keycloak.lab.chxmxii.xyz` | `keycloak/keycloak-service` | Keycloak itself |
| `prometheus.lab.chxmxii.xyz` | `monitoring/kube-prometheus-stack-prometheus` | Gateway SSO |
| `alerts.lab.chxmxii.xyz` | `monitoring/kube-prometheus-stack-alertmanager` | Gateway SSO |
| `longhorn.lab.chxmxii.xyz` | `longhorn-system/longhorn-frontend` | Gateway SSO |
| `hubble.lab.chxmxii.xyz` | `kube-system/hubble-ui` | Gateway SSO |

Every route adds `Strict-Transport-Security`, `X-Content-Type-Options` and `Referrer-Policy` headers and strips `Server` and `X-Powered-By`. A `ClientTrafficPolicy` sets TLS 1.2 as the minimum and a 30 second limit on receiving a request.

Routes, listeners and SSO policies all live in `kubernetes/apps/networking/edge/manifests`. To publish a new app, add a listener to `gateway.yaml` and a file under `routes/`.

## Certificates: cert-manager

The `cert-manager.io/cluster-issuer: letsencrypt` annotation on the Gateway makes cert-manager request one certificate per HTTPS listener. Challenges use HTTP-01 through the Gateway's HTTP listener, so port 80 on `10.254.100.205` must be reachable from the internet while a certificate is being issued or renewed.

## Remote access: NetBird

The NetBird operator runs two routing peers in the `netbird` namespace. They publish the edge gateway's Service as a NetBird network resource, so any peer in the `homelab-admins` NetBird group can reach every hostname above from anywhere, without opening ports on your router.

Setup steps are in [Secrets and first-time setup](/kubegoros/getting-started/secrets/).
