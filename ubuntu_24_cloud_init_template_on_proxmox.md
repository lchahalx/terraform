
# **Creating an Ubuntu 24.04 Cloud-Init Template on Proxmox for Kubernetes**

## **Objective**
This guide outlines the steps to create an **Ubuntu 24.04** cloud-init template on Proxmox, which can be cloned for use in a Kubernetes cluster setup using Terraform.

---

## **Pre-requisites**
- A **Proxmox VE 8.4.1** or higher installation.
- **Root access** to the Proxmox server.
- **Ubuntu 24.04 cloud image** available for download.

---

## **Steps to Create the Template**

### **Step 1: Download the Official Ubuntu 24.04 Cloud Image**

1. SSH into your Proxmox server as **root**.
2. Navigate to the `iso` folder:
   ```bash
   cd /var/lib/vz/template/iso/
   ```
3. Download the Ubuntu 24.04 cloud image:
   ```bash
   wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
   ```

### **Step 2: Create a New VM (Temporary)**

1. Create a new VM that will later become the cloud-init template:
   ```bash
   qm create 9000 --name ubuntu-24-04-template --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
   ```
   - **9000**: The VMID (can be any unused number, but high numbers like 9000-9999 are ideal for templates).
   - Adjust `--memory` and `--cores` as needed.
   - `bridge=vmbr0`: Ensure `vmbr0` is the correct network bridge on your Proxmox server (check with `cat /etc/network/interfaces` if unsure).

### **Step 3: Import the Ubuntu Disk**

1. Import the cloud image into the created VM:
   ```bash
   qm importdisk 9000 noble-server-cloudimg-amd64.img local-lvm
   ```
   - If your storage is `ssd500g`, use:
     ```bash
     qm importdisk 9000 noble-server-cloudimg-amd64.img ssd500g
     ```

### **Step 4: Attach the Imported Disk to the VM**

1. Attach the disk to the VM:
   ```bash
   qm set 9000 --scsihw virtio-scsi-pci --scsi0 ssd500g:vm-9000-disk-0
   ```
   - `virtio-scsi-pci` is the best choice for cloud images.
   - Adjust storage pool (`ssd500g`) as needed.

### **Step 5: Configure Cloud-Init**

1. Enable cloud-init for the VM:
   ```bash
   qm set 9000 --ide2 ssd500g:cloudinit
   qm set 9000 --boot c --bootdisk scsi0
   qm set 9000 --serial0 socket --vga serial0
   ```

### **Step 6: Customize the Template (Optional)**

1. Set a default user and SSH key:
   ```bash
   qm set 9000 --ciuser lchahal --sshkey ~/.ssh/id_ed25519.pub
   ```

### **Step 7: Convert to Template**

1. Convert the VM to a template:
   ```bash
   qm template 9000
   ```

---

## **Verifying the Template**

1. List available templates to confirm:
   ```bash
   qm list
   ```
   - Ensure `ubuntu-24-04-template` is listed as a template.

---

## **Using the Template with Terraform**

1. Update the Terraform variable for the template in `variables.tf`:
   ```hcl
   variable "template" { default = "ubuntu-24-04-template" }
   ```

2. After updating the variable, Terraform can now use the new **Ubuntu 24.04** cloud-init template to create Kubernetes nodes.

---

## **Critical Considerations**

| **Topic**  | **Reminder**  |
|------------|---------------|
| **Storage** | Ensure you're using the correct storage pool (`ssd500g`) in both the template creation and Terraform configurations. |
| **Network** | Double-check that `vmbr0` is the correct network bridge on your Proxmox server. |
| **SSH Keys** | Cloud-init SSH key support is enabled. Without this, remote access will not be possible. |
| **Cloud-Init** | Cloud-init ensures automatic IP assignment, user creation, and hostname setting in cloned VMs. |

---

## **Conclusion**

You now have a ready-to-use **Ubuntu 24.04 cloud-init template** on Proxmox, which can be cloned for Kubernetes worker and master nodes using Terraform. The process is fully automated and scalable.

---
