---
controlplane_firewall_ports:
  - 10248 #kubelet healthz
  - 4240  #cilium health
  - 4244  #hubble server
  - 8472/udp #cilium vxlan
  - 2379  #etcd-client
  - 2380  #etcd
  - 10250 #kubelet
  - 6443  #kube-api
  - 10257 #kube-controller-manager
  - 10259 #kube-scheduler

worker_firewall_ports:
  - 10250 #kubelet
  - 4240  #cilium health
  - 4244  #hubble server
  - 8472/udp #cilium vxlan
  - 30000-32767 #nodePorts

firewall_services:
  - http
  - https
