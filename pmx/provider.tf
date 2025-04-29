terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}



provider "proxmox" {
    pm_api_url = "http://192.168.2.165:8006/api2/json"
    pm_api_token_id      = "lchahal@pam!terraform"
    pm_api_token_secret  = var.pm_api_token_secret
    pm_tls_insecure      = true
}
  
