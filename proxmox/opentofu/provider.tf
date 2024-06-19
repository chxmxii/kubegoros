terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}


provider "proxmox" {
  endpoint  = var.proxmox_api_endpoint
  # api_token = var.proxmox_api_token
  # insecure  = true

  ssh {
    agent = true
    # username = "root"
    # password = "8krsoklrX2vtq7nF"
    # private_key = file("/root/.ssh/id_rsa")
  }
}

