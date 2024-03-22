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
## <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Tux.svg/640px-Tux.svg.png" alt="UNIX Like Systems" width="20" height="25"  style="vertical-align:top; margin:4px"> Project Strcuture

```sh
📁 cluster-template
├── 📁 kubernetes                # Kubernetes directory
|   ├── 📁 main-applications     # Main applications
|   └── 📁 add-ons               # Add-ons applications
└── 📁 ansible                   # Ansible directory 
|   ├── 📁 playbooks             # Ansible playbooks
|   ├── 📁 roles                 # Ansible roles
|   └── 📁 tests                 # Ansible tests
└── 📁 .taskfiles                # Taskfiles directory
    ├── 📄 clusterTasks.yml       # Tasks specific to cluster management
    └── 📄 otherTasks.yml         # Other tasks related to the project

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
        <td><img width="32" src="x"></td>
        <td><a href="https://www.projectcalico.org">Calico</a></td>
        <td>eBPF-based Networking, Observability and Security (CNI, LB, Network Policy, etc.)</td>
    </tr>
    <tr>
        <td><img width="32" src="https://prometheus.io/assets/icon-prometheus-mascot.png"></td>
        <td><a href="https://prometheus.io">Prometheus</a></td>
        <td>Systems monitoring and alerting toolkit</td>
    </tr>
    <tr>
        <td><img width="32" src="https://vector.dev/img/logos/vector.svg"></td>
        <td><a href="https://vector.dev">Vector</a></td>
        <td>High-performance observability data router</td>
    </tr>
    <tr>
        <td><img width="32" src="https://github.com/grafana/loki/blob/main/docs/sources/logo.png?raw=true"></td>
        <td><a href="https://grafana.com/oss/loki">Loki</a></td>
        <td>Log aggregation system</td>
    </tr>
    <tr>
        <td><img width="32" src="https://www.vaultproject.io/img/brand/vault_logo_32.png"></td>
        <td><a href="https://www.vaultproject.io">Vault</a></td>
        <td>Secret management and data protection</td>
    </tr>
    <tr>
        <td><img width="32" src="https://yverno.dev/img/yverno-logo.svg"></td>
        <td><a href="https://yverno.dev">Kyverno</a></td>
        <td>Declarative policy engine for Kubernetes configuration</td>
    </tr>
    <tr>
        <td><img width="32" src="https://kanidm.com/images/logo.svg"></td>
        <td><a href="https://kanidm.com">Kanidm</a></td>
        <td>Modern and simple identity management platform</td>
    </tr>
    <tr>
        <td><img width="32" src="https://istio.io/latest/img/istio-whitelogo-bluebackground-unframed.svg"></td>
        <td><a href="https://istio.io">Istio</a></td>
        <td>Service mesh for connecting, securing, and managing microservices</td>
    </tr>
    <tr>
        <td><img width="32" src="https://kubearmor.io/images/logo_black.png"></td>
        <td><a href="https://kubearmor.io">KubeArmor</a></td>
        <td>Kubernetes Native Runtime Security</td>
    </tr>
    <tr>
        <td><img width="32" src="https://metallb.org/images/logo.svg"></td>
        <td><a href="https://metallb.org">MetalLB</a></td>
        <td>Bare metal load-balancer for Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://nginx.org/nginx.png"></td>
        <td><a href="https://www.nginx.com">NGINX Ingress Controller</a></td>
        <td>Kubernetes Ingress Controller</td>
    </tr>
    <tr>
        <td><img width="32" src="https://longhorn.io/img/logos/longhorn-icon-white.png"></td>
        <td><a href="https://longhorn.io">Longhorn</a></td>
        <td>Cloud native distributed block storage for Kubernetes</td>
    </tr>
    <tr>
        <td><img width="32" src="https://velero.io/img/velero-logo.png"></td>
        <td><a href="https://velero.io">Velero</a></td>
        <td>Backup and disaster recovery solution for Kubernetes clusters</td>
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

KUBE-X is licensed under the  GPLv3 License. See the [LICENSE](LICENSE.md) file for details.



