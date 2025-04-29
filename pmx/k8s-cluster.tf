resource "proxmox_vm_qemu" "k8s-master" {
  count       = var.k8s_master_count  
  name        = "k8s-master-${count.index}"
  target_node = var.node
  clone       = var.template
  cores       = 4
  memory      = 4096

  disk {
    type    = "disk"
    size    = "30G"
    storage = "ssd500g"
    format  = "raw"
    slot    = "scsi0"
   }
  ipconfig0   = "ip=192.168.2.${120 + count.index}/24,gw=192.168.2.1"
  ssh_user = "lchahal"
  sshkeys     = file("~/.ssh/id_ed25519.pub")

}

resource "proxmox_vm_qemu" "k8s-worker" {
  count       = var.k8s_worker_count
  name        = "k8s-worker-${count.index}"
  target_node = var.node
  clone       = var.template
  cores       = 2
  memory      = 5120
  
  disk {
    type    = "disk"
    size    = "50G"
    storage = "ssd500g"
    format  = "raw"
    slot    = "scsi0"
  }

  ipconfig0   = "ip=192.168.2.${116 + count.index}/24,gw=192.168.2.1"

  ssh_user = "lchahal"
  sshkeys     = file("~/.ssh/id_ed25519.pub")
}
