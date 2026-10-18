---
title: Observability
description: Metrics, logs and network flows.
sidebar:
  order: 5
---

## Metrics

kube-prometheus-stack runs Prometheus, Alertmanager (2 replicas), Grafana, node-exporter and kube-state-metrics in `monitoring`. Prometheus picks up every `ServiceMonitor`, `PodMonitor` and `ScrapeConfig` in the cluster, regardless of labels. Apps that ship monitors: Cilium and Hubble, Loki, Vector, Longhorn, CloudNativePG, Envoy Gateway, metrics-server.

HAProxy and keepalived on the load balancers are scraped by `ScrapeConfig` objects in `kubernetes/apps/monitoring/kube-prometheus-stack/chart/scrapeconfig`.

Grafana dashboards come from ConfigMaps labelled `grafana_dashboard: "1"`. The `grafana_folder` annotation picks the folder.

## Logs

Vector runs on every node and tails all container logs. Each line is sent to Loki with these labels:

| Label | From |
|---|---|
| `namespace` | pod namespace |
| `app` | `app.kubernetes.io/name`, then `app`, then container name |
| `container` | container name |
| `node` | node name |
| `stream` | `stdout` or `stderr` |

The pod name is stored as structured metadata rather than a label, which keeps the number of streams low. Query it with `| pod="..."`.

Loki runs as a single binary with filesystem storage on a Longhorn volume and keeps 30 days. In Grafana, the `Loki` data source is already configured:

```txt
{namespace="argocd", stream="stderr"} |= "error"
```

## Network flows

Hubble records flows from Cilium. Use the UI at `https://hubble.lab.chxmxii.xyz` or the CLI:

```bash
cilium hubble port-forward &
hubble observe --namespace keycloak --verdict DROPPED
```

Dropped flows are the first thing to check after adding a NetworkPolicy.
