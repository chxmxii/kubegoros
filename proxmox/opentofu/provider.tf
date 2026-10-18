terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.117.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.14.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.3.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.1"
    }
  }
}


provider "proxmox" {
  endpoint  = var.proxmox_api_endpoint
  
  ssh {
    agent = true
  }
}