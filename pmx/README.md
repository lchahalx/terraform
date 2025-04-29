
# Kubernetes Cluster Setup on Proxmox

## Overview

This Terraform project automates the creation of a Kubernetes cluster with both master and worker nodes on a Proxmox environment. It configures virtual machines (VMs) on Proxmox, creating the desired infrastructure based on the configuration files.

## Prerequisites

- **Terraform**: Version 1.11 or higher
- **Proxmox VE environment**: Must be running and accessible via API
- **Proxmox API credentials**: Required for interacting with Proxmox resources
- **SSH keys**: Ensure your SSH public key is placed at `~/.ssh/id_ed25519.pub` for accessing VMs
- **Proxmox VM Template**: A template to clone for the VMs (e.g., a Ubuntu template)

## Directory Structure

```
.
├── backend.tf         # Backend configuration for Terraform state
├── k8s-cluster.tf     # Proxmox VM resources for the Kubernetes cluster
├── provider.tf        # Provider configuration (Proxmox)
├── terraform.tfvars   # Variable values to pass into the configuration
├── variables.tf       # Variable definitions
└── README.md          # Project documentation
```

## File Descriptions

### `backend.tf`

This file configures the Terraform backend, which is used to store the state of your Terraform resources. It can be used to configure remote backends such as AWS S3, GCS, or local backend storage.

Example:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "k8s-cluster.tfstate"
    region = "us-east-1"
  }
}
```

### `k8s-cluster.tf`

This file contains the main configuration for creating the Proxmox VM resources for the Kubernetes master and worker nodes. It defines the resources, their configurations, disk sizes, network settings, etc.

Example:

```hcl
resource "proxmox_vm_qemu" "k8s-master" {
  count       = var.k8s_master_count
  name        = "k8s-master-${count.index}"
  cores       = 2
  memory      = 4096
  disk {
    size      = "30G"
    slot      = "scsi0"
    type      = "disk"
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  ssh_keys = file("~/.ssh/id_ed25519.pub")
  clone = var.template
  node  = var.proxmox_node
}

resource "proxmox_vm_qemu" "k8s-worker" {
  count       = var.k8s_worker_count
  name        = "k8s-worker-${count.index}"
  cores       = 2
  memory      = 4096
  disk {
    size      = "50G"
    slot      = "scsi0"
    type      = "disk"
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  ssh_keys = file("~/.ssh/id_ed25519.pub")
  clone = var.template
  node  = var.proxmox_node
}
```

### `provider.tf`

This file contains the configuration for the Terraform provider. In this case, it's configuring the Proxmox provider to interact with the Proxmox API.

Example:

```hcl
provider "proxmox" {
  pm_api_url = "https://your-proxmox-server:8006 api2/json"
  pm_user    = "root@pam!terraform"
  pm_api_token_secret  = var.pm_api_token_secret
  pm_tls_insecure = true
}
```

### `terraform.tfvars`

This file contains the variable values that will be used in the Terraform configuration. It's helpful for managing environment-specific configurations.

Example:

```hcl
k8s_master_count = 1
k8s_worker_count = 2
proxmox_node = "your-proxmox-node"
template = "your-template-name"
```

### `variables.tf`

This file defines the input variables used in your configuration, including defaults and descriptions.

Example:

```hcl
variable "k8s_master_count" {
  description = "The number of Kubernetes master nodes to create"
  default     = 1
}

variable "k8s_worker_count" {
  description = "The number of Kubernetes worker nodes to create"
  default     = 2
}

variable "proxmox_node" {
  description = "The Proxmox node where the VMs will be created"
}

variable "template" {
  description = "The template to use for cloning VMs"
}
```

## Usage

1. **Clone the repository and navigate to the project directory**:
    ```bash
    git clone <repository_url>
    cd k8s-cluster-setup
    ```

2. **Initialize Terraform**:
    ```bash
    terraform init
    ```

3. **Review the Terraform plan**:
    ```bash
    terraform plan 

4. **Apply the Terraform plan**:
    ```bash
    terraform apply
    ```

## Notes

- Ensure your Proxmox environment has sufficient resources (CPU, RAM, storage) to create the number of VMs defined in `terraform.tfvars`.
- SSH access is configured with the SSH key located in `~/.ssh/id_ed25519.pub`.
- Modify the `terraform.tfvars` file to suit your environment and configuration preferences (e.g., node count, template name).
- If you are using a remote backend for Terraform state, ensure that your backend configuration in `backend.tf` is correctly set up.
