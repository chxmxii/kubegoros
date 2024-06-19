resource "null_resource" "coreos_qcow2" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -L https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/40.20240519.3.0/x86_64/fedora-coreos-40.20240519.3.0-qemu.x86_64.qcow2.xz -o fedora-coreos.qcow2.xz && \
      unxz fedora-coreos.qcow2.xz && \
      mv fedora-coreos.qcow2 fedora-coreos.qcow2.iso
    EOT
  }

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "rm -f fedora-coreos.qcow2.iso"
  # }
}

resource "proxmox_virtual_environment_file" "coreos_qcow2" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_host

  depends_on = [null_resource.coreos_qcow2]

  source_file {
    path = "fedora-coreos.qcow2.iso"
  }
}