variable "pm_api_token_secret" {
  description = "Proxmox API token secret for authentication"
  type        = string
}

variable "node" {
  description = "Proxmox node where VMs will be created"
  default     = "proxmox-node-name"
}

variable "template" {
  description = "The Proxmox VM template to be cloned for Kubernetes nodes"
  default     = "ubuntu-24-04-template"
}

variable "k8s_master_count" {
  description = "The number of Kubernetes master nodes to create"
  default     = 1
}

variable "k8s_worker_count" {
  description = "The number of Kubernetes worker nodes to create"
  default     = 2
}
