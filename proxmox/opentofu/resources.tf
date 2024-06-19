resource "proxmox_virtual_environment_vm" "k8s_controlplanes" {
  count = var.controlplane_nodes

  name        = "KC-CONTROLPLANE-${count.index + 1}"
  node_name   = var.proxmox_host
  description = "Kubernetes Controlplane Nodes - Managed by OpenTofu"

  machine = "q35"  

  agent {
    enabled = true
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local"
    interface    = "scsi0"
    file_id      = proxmox_virtual_environment_file.coreos_qcow2.id
    size         = "10"
    file_format  = "qcow2"
  }
  
  network_device {
    bridge = "vmbr1"
  }
  
  kvm_arguments = "-fw_cfg 'name=opt/com.coreos/config,string=${replace(data.ct_config.node_ignition.rendered, ",", ",,")}'"
}

resource "proxmox_virtual_environment_vm" "k8s_workernodes" {
  count = var.worker_nodes

  name        = "KC-WORKERNODE-${count.index + 1}"
  node_name   = var.proxmox_host
  description = "Kubernetes Worker Nodes - Managed by OpenTofu"

  machine = "q35"  

  agent {
    enabled = true
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local"
    interface    = "scsi0"
    file_id      = proxmox_virtual_environment_file.coreos_qcow2.id
    size         = "10"
    file_format  = "qcow2"
  }

  network_device {
    bridge = "vmbr1"
  }
  
  kvm_arguments = "-fw_cfg 'name=opt/com.coreos/config,string=${replace(data.ct_config.node_ignition.rendered, ",", ",,")}'"
}
