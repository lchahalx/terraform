terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}



provider "proxmox" {
    pm_api_url = "http://>proxmox_server>:8006/api2/json"
    pm_api_token_id      = "<token>"
    pm_api_token_secret  = var.pm_api_token_secret
    pm_tls_insecure      = true
}
  
