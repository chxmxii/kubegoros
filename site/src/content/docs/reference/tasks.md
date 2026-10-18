---
title: Tasks
description: Every task command and the playbook behind it.
---

Run `task help` for the short version.

| Command | Runs | What it does |
|---|---|---|
| `task env:prepare` | `python3 -m venv .venv` | Creates the virtualenv |
| `task env:install` | pip, ansible-galaxy | Installs `requirements.txt` and `requirements.yml` |
| `task nodes:check` | `ansible all -m ping` | Checks SSH and Python on every host |
| `task nodes:list` | `ansible-inventory --graph` | Shows the inventory |
| `task nodes:reboot` | `systemctl reboot` | Reboots every host at once. Not for a running cluster |
| `task cluster:init` | `cluster.yml --tags cluster` | Builds or completes the cluster |
| `task cluster:upgrade VERSION=1.xx` | `upgrade.yml` | One minor version, node by node |
| `task cluster:harden` | `harden-controlplane.yml` | Audit, encryption at rest and OIDC on an existing cluster (1.34 or later) |
| `task cluster:verify` | `verify.yml` | Read-only smoke test |
| `task cluster:reset` | `reset.yml` | Destroys the cluster on every node, asks first |
| `task policy:enable` | `kyverno_policies.yml` | Applies the policies in `ansible/playbooks/files/policies` |
| `task policy:disable` | `kyverno_policies.yml` | Removes them |

The load balancers are not in any task. Configure them with:

```bash
ansible-playbook ansible/playbooks/cluster.yml --tags haproxy
```
