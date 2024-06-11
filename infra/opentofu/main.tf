
resource "proxmox_vm_qemu" "your-vm" {

    # VM General Settings
    target_node = "your-proxmox-node"
    vmid = "100"
    name = "vm-name"
    desc = "Description"

    # VM Advanced General Settings
    onboot = true

    # VM OS Settings
    clone = "your-clone"

    # VM System Settings
    agent = 1

    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu = "host"    

    # VM Memory Settings
    memory = 1024

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    disk {
        storage = "local-lvm"
        type = "virtio"
        size = "20G"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=0.0.0.0/0,gw=0.0.0.0"

    # If your packer image template already has a user and ssh key created then only use this step
    # to create an additional user and ssh key pair

    # (Optional) Default User
    # ciuser = "your-username"
    # (Optional) Add your SSH KEY

    # sshkeys = <<EOF
    # #YOUR-PUBLIC-SSH-KEY
    # EOF

}