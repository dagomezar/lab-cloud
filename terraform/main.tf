terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id      = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure      = true
}

# --- VM 200: INFRA / OPS ---
resource "proxmox_vm_qemu" "infra_server" {
  name        = "lab-ops-01"
  target_node = "pve0"
  vmid        = 200
  clone       = "ubuntu-2404-template"
  full_clone  = true
  os_type     = "cloud-init"
  agent       = 1
  start_at_node_boot = true

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }
  memory = 4096
  scsihw = "virtio-scsi-pci"

  serial {
    id   = 0
    type = "socket"
  }

  disk {
    slot     = "scsi0"
    size     = "20G"
    type     = "disk"
    storage  = "local-lvm"
    iothread = true
  }

  disk {
    slot     = "scsi1"
    size     = "15G"
    type     = "disk"
    storage  = "local-lvm"
    iothread = true
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }

  network {
    id       = 1
    model    = "virtio"
    bridge   = "vmbr1"
    firewall = false
  }

  ciuser     = "dbre_admin"
  cipassword = "SoporteDBA"
  ssh_user   = "dbre_admin"
  #sshkeys    = var.ssh_key_dagomez # Usando variable para limpieza o pega tu llave aquí directamente
  sshkeys = var.ssh_key

  ipconfig0 = "ip=192.168.1.200/24,gw=192.168.1.1"
  ipconfig1 = "ip=10.0.0.20/24"
}

# --- VM 201: POSTGRES LEGACY ---
resource "proxmox_vm_qemu" "postgres_legacy" {
  name        = "postgres-legacy"
  vmid        = 201
  target_node = "pve0"
  clone       = "ubuntu-2404-template"
  agent       = 1
  os_type     = "cloud-init"

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }
  memory  = 8192
  scsihw  = "virtio-scsi-pci"

  serial {
    id   = 0
    type = "socket"
  }

  disk {
    slot     = "scsi0"
    size     = "30G"
    type     = "disk"
    storage  = "local-lvm"
    iothread = true
    discard  = true
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }

  ipconfig0 = "ip=192.168.1.201/24,gw=192.168.1.1"
  ciuser     = "dbre_admin"
  cipassword = "SoporteDBA"
  ssh_user   = "dbre_admin"
  #sshkeys    = var.ssh_key_dagomez
  sshkeys = var.ssh_key
}

# --- VM 203: K8S NODE (AJUSTADO A 8GB) ---
resource "proxmox_vm_qemu" "k8s_node" {
  name        = "k8s-node"
  target_node = "pve0"
  vmid        = 203
  clone       = "ubuntu-2404-template"
  agent       = 1
  os_type     = "cloud-init"

  memory  = 8192 # <--- Bajado de 12GB a 8GB
  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  serial {
    id   = 0
    type = "socket"
  }

  scsihw   = "virtio-scsi-pci"
  boot     = "order=scsi0"

  disk {
    slot     = "scsi0"
    size     = "40G"
    type     = "disk"
    storage  = "local-lvm"
    iothread = true
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }

  ipconfig0 = "ip=192.168.1.203/24,gw=192.168.1.1"
  ciuser     = "dbre_admin"
  cipassword = "SoporteDBA"
  ssh_user   = "dbre_admin"
  #sshkeys    = var.ssh_key_dagomez
  sshkeys = var.ssh_key
}
