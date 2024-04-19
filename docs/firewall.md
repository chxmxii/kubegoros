---
controlplane_firewall_ports:
  - 10248 #kubelet
  - 10249 #kube-proxy
  - 9099  #calico
  - 2379  #etcd-client
  - 2380  #etcd
  - 10250 #kubelet
  - 6443  #kube-api
  - 10256 #kube-proxy
  - 10257 #kube-controll
  - 10259 #kube-scheduler

worker_firewall_ports:
  - 10250 #kubelet
  - 30000-32767 #nodePorts

firewall_services:
  - http
  - https

