---
title: Requirements
description: Machines, network and tools you need before building the cluster.
sidebar:
  order: 1
---

## Machines

| Role | Count | Suggested size | OS |
|---|---|---|---|
| Control plane | 3 | 2 vCPU, 4 GB RAM | EL8 or EL9 (Rocky, Alma, RHEL) |
| Worker | 3 | 4 vCPU, 8 GB RAM, a data disk for Longhorn | EL8 or EL9 |
| Load balancer (HAProxy, keepalived) | 2 | 1 vCPU, 1 GB RAM | EL8 or EL9 |

The roles check this before changing anything and stop on:

- rpm-ostree systems such as Fedora CoreOS (the images built by `proxmox/opentofu`),
- anything older than EL8, including the CentOS 7 load balancers the cluster used to run on,
- hosts booted with cgroup v1. Kubernetes 1.35 and later refuse to start on them.

To switch an EL8 host to cgroup v2:

```bash
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=1"
sudo reboot
stat -fc %T /sys/fs/cgroup   # cgroup2fs
```

## Network

| Address | Used for |
|---|---|
| `10.254.100.99` | API server VIP held by keepalived |
| `10.254.100.205` | Edge gateway (all web UIs) |
| `10.254.100.205` to `.215`, `.70` to `.85` | MetalLB pools |
| `10.254.100.107:8200` | Vault |
| `10.244.0.0/16` | Pods |
| `10.96.0.0/16` | Services |

DNS: point `*.lab.chxmxii.xyz` at `10.254.100.205`. Let's Encrypt has to reach port 80 on that address for HTTP-01 challenges.

## Workstation

- [Task](https://taskfile.dev) and Python 3.10 or newer
- `kubectl` and [kubelogin](https://github.com/int128/kubelogin)
- the `vault` CLI, logged in to your Vault
- SSH access as `ansible` to every host, with sudo

Then install the Ansible dependencies into `.venv`:

```bash
task env:prepare
task env:install
```
