variable proxmox_host {
  type = string
  default = "ns31212248"
}

variable "proxmox_api_endpoint" {
  type = string
  description = "Proxmox API endpoint"
}

# variable "proxmox_api_token" {
#   type = string
#   description = "Proxmox API token bpg proxmox provider with ID and token"
# }

variable "controlplane_nodes" {
  description = "Number of control plane nodes in the Kubernetes cluster."
  type        = number
  default     = 1
}

variable "worker_nodes" {
  description = "Number of worker nodes in the Kubernetes cluster."
  type        = number
  default     = 1
}

variable "node_os_image" {
  description = "Operating system image to use for the nodes."
  type        = string
  default     = "fedora-coreos-39.20240407.3.0-live.x86_64.iso"
}
