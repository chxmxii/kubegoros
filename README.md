<div align="center">
  
#  <img src="https://media.giphy.com/media/3o7aD2d7hy9ktXNDP2/giphy.gif" width="35"> KUBE-X  <img src="https://media.giphy.com/media/3o7aD2d7hy9ktXNDP2/giphy.gif" width="35">
Simplifying Bare-Metal Production-Grade Kubernetes Deployment 🚀
</div>

---
##  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/640px-Tux.svg.png" alt="UNIX Like Systems" width="20" height="25"  style="vertical-align:top; margin:4px"> What's this?

KUBE-X is a declarative, GitOps-based tool designed to simplify the deployment of production-ready bare-metal Kubernetes clusters. It empowers users to define and manage their Kubernetes infrastructure declaratively, streamlining the deployment process. With KUBE-X, you can easily provision and manage your bare-metal Kubernetes clusters using GitOps principles.

---
## <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/640px-Tux.svg.png" alt="UNIX Like Systems" width="20" height="25"  style="vertical-align:top; margin:4px"> Architecture
![Kube-X arch](arch.png)
---
## <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/640px-Tux.svg.png" alt="UNIX Like Systems" width="20" height="25"  style="vertical-align:top; margin:4px"> Features

- 📦 Declarative deployment of production-ready bare-metal Kubernetes clusters.
- 🛠️ GitOps-based approach for managing Kubernetes infrastructure.
- 🔄 Streamlined provisioning and management of clusters.
- 🚀 Simplified application deployment and configuration.
- 🔧 Customizable configurations for specific use cases.

---

## <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/640px-Tux.svg.png" alt="UNIX Like Systems" width="20" height="25"  style="vertical-align:top; margin:4px"> Prerequisites

Before getting started, ensure you have:
```
- Ansible > 2.9.15
```
---

## <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/640px-Tux.svg.png" alt="UNIX Like Systems" width="20" height="25"  style="vertical-align:top; margin:4px"> Installation

Follow these steps to install KUBE-X:
```
1. git clone github.com/chxmxii/kubex.git
2. pip3 install -r requirements.txt
3. ansible-galaxy collection install -r requirements.yml
```
---

```sh
📁 cluster-template
├── 📁 kubernetes        # Kubernetes directory
│   ├── 📁 apps          # Main applications
│   ├── 📁 add-ons       # Add-ons applications
└── 📁 ansible           # Ansible directory 
    ├── 📁 playbooks     # Playbooks
    ├── 📁 roles         # Ansible roles
    └── 📁 tests         # Ansible tests
```
---
## <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/640px-Tux.svg.png" alt="UNIX Like Systems" width="20" height="25"  style="vertical-align:top; margin:4px"> Stack
<table>
    <tr>
        <th>Logo</th>
        <th>Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><img width="32" src="https://simpleicons.org/icons/ansible.svg"></td>
        <td><a href="https://www.ansible.com">Ansible</a></td>
        <td>Automate bare metal provisioning and configuration</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/30269780"></td>
        <td><a href="https://argoproj.github.io/cd">ArgoCD</a></td>
        <td>GitOps tool built to deploy applications to Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://github.com/jetstack/cert-manager/raw/master/logo/logo.png"></td>
        <td><a href="https://cert-manager.io">cert-manager</a></td>
        <td>Cloud native certificate management</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/21054566?s=200&v=4"></td>
        <td><a href="https://cilium.io">Cilium</a></td>
        <td>eBPF-based Networking, Observability and Security (CNI, LB, Network Policy, etc.)</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/314135?s=200&v=4"></td>
        <td><a href="https://www.cloudflare.com">Cloudflare</a></td>
        <td>DNS and Tunnel</td>
    </tr>
    <tr>
        <td><img width="32" src="https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png"></td>
        <td><a href="https://www.docker.com">Docker</a></td>
        <td>Ephemeral PXE server and convenient tools container</td>
    </tr>
    <tr>
        <td><img width="32" src="https://github.com/distribution/distribution/raw/main/distribution-logo.svg"></td>
        <td><a href="https://github.com/distribution/distribution">Docker Registry</a></td>
        <td>Private container registry</td>
    </tr>
    <tr>
        <td><img width="32" src="https://github.com/kubernetes-sigs/external-dns/raw/master/docs/img/external-dns.png"></td>
        <td><a href="https://github.com/kubernetes-sigs/external-dns">ExternalDNS</a></td>
        <td>Synchronizes exposed Kubernetes Services and Ingresses with DNS providers</td>
    </tr>
    <tr>
        <td><img width="32" src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Fedora_logo.svg/267px-Fedora_logo.svg.png"></td>
        <td><a href="https://getfedora.org/en/server">Fedora Server</a></td>
        <td>Base OS for Kubernetes nodes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://upload.wikimedia.org/wikipedia/commons/b/bb/Gitea_Logo.svg"></td>
        <td><a href="https://gitea.com">Gitea</a></td>
        <td>Self-hosted Git service</td>
    </tr>
    <tr>
        <td><img width="32" src="https://grafana.com/static/img/menu/grafana2.svg"></td>
        <td><a href="https://grafana.com">Grafana</a></td>
        <td>Observability platform</td>
    </tr>
    <tr>
        <td><img width="32" src="https://helm.sh/img/helm.svg"></td>
        <td><a href="https://helm.sh">Helm</a></td>
        <td>The package manager for Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/49319725"></td>
        <td><a href="https://k3s.io">K3s</a></td>
        <td>Lightweight distribution of Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://kanidm.com/images/logo.svg"></td>
        <td><a href="https://kanidm.com">Kanidm</a></td>
        <td>Modern and simple identity management platform</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/13629408"></td>
        <td><a href="https://kubernetes.io">Kubernetes</a></td>
        <td>Container-orchestration system, the backbone of this project</td>
    </tr>
    <tr>
        <td><img width="32" src="https://github.com/grafana/loki/blob/main/docs/sources/logo.png?raw=true"></td>
        <td><a href="https://grafana.com/oss/loki">Loki</a></td>
        <td>Log aggregation system</td>
    </tr>
    <tr>
        <td><img width="32" src="https://longhorn.io/img/logos/longhorn-icon-white.png"></td>
        <td><a href="https://longhorn.io">Longhorn</a></td>
        <td>Cloud native distributed block storage for Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/1412239?s=200&v=4"></td>
        <td><a href="https://www.nginx.com">NGINX</a></td>
        <td>Kubernetes Ingress Controller</td>
    </tr>
    <tr>
        <td><img width="32" src="https://ntfy.sh/_next/static/media/logo.077f6a13.svg"></td>
        <td><a href="https://ntfy.sh">ntfy</a></td>
        <td>Notification service to send notifications to your phone or desktop</td>
    </tr>
    <tr>
        <td><img width="32" src="https://avatars.githubusercontent.com/u/3380462"></td>
        <td><a href="https://prometheus.io">Prometheus</a></td>
        <td>Systems monitoring and alerting toolkit</td>
    </tr>
    <tr>
        <td><img width="32" src="https://docs.renovatebot.com/assets/images/logo.png"></td>
        <td><a href="https://www.whitesourcesoftware.com/free-developer-tools/renovate">Renovate</a></td>
        <td>Automatically update dependencies</td>
    </tr>
</table>

---
## <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/640px-Tux.svg.png" alt="UNIX Like Systems" width="20" height="25"  style="vertical-align:top; margin:4px"> Usage

Once installed and configured, use KUBE-X to deploy and manage your Kubernetes cluster:

```bash
$ cd kubex
$ task cluster:init
```
---
## Contributing

Contributions are welcome! To contribute to KUBE-X, follow these guidelines:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Test your changes thoroughly.
5. Submit a pull request.

---

## License

KUBE-X is licensed under the [License Name]. See the [LICENSE](LICENSE) file for details.


