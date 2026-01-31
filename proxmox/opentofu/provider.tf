terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.93.1"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.14.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.6.2"
    }
  }
}


provider "proxmox" {
  endpoint  = var.proxmox_api_endpoint
  
  ssh {
    agent = true
  }
}