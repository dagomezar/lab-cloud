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

resource "proxmox_vm_qemu" "infra_server" {
  name        = "lab-ops-01"
  target_node = "pve0"
  vmid        = 200
  clone       = "ubuntu-2404-template"
  full_clone  = true
  
  os_type   = "cloud-init"
  agent     = 1
  start_at_node_boot = true

  # Hardware
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }
  memory = 4096
  scsihw = "virtio-scsi-pci"

  # Almacenamiento
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

  # Red
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    id     = 1
    model  = "virtio"
    bridge = "vmbr1"
  }

  # Cloud-Init Config (LA CLAVE ESTÁ AQUÍ)
  ciuser     = "dbre_admin"
  cipassword = "SoporteDBA"
  ssh_user   = "dbre_admin"
  
  # Importante: No dejes espacios antes de ssh-rsa
  sshkeys = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDO/vuTYIHqlF7JV41j5KEW9XUQtSa4XK688aWoCYyzbDSjp1EEvLvmBpwMWNEBQeOO8DQsCcmM07sFr1HmXN2z6sZJCazH6qIX0fIRaKnR/8Uo7QKvRPTt5JEsqE/Gk7b0oUg7EeaQSMpgu5UzF8MKmXPOQiHvGr/tpsqw/7JPTrbNbfvMAyJqafmuz7TsStRFQ/wos27TF1eDtuMIdtPMCgaUOgO9OUuSzngRqUspqPJmcqSR80PBye0vEhjM0FB+MOHwp9ytJZGUvl4jJZoP84Eui9eCKfum5CzVGpaUIDhx02wKHWLWJiGyAEVFZbaRMi+km4BUAlOGESz6uRSqe60T3N5NV2JTaUEOamSRLw/Q0zF4SAX4RG2Av5CNOazdWmOP2PI2pQABdQ77TnWwpUUXFJQ0xv7XMstsIz6JKIcjF/bNo6JljRm9U+HYOS/JPO4pOHbY/Vh/P509dhvfUBtkYEOckhG7qDR+rPfBzWX0SfZAO2JUrrZ6KqPUOUV9nzYFS8+oUcWvw5n5aVbinPIdgXFrPgIdf3q2Y6ph39SBjrtjWO/6f/VsbUeSdahALw6S2M/ep7GlHjObT/Dhfg7zlZjeAz8UUUfP2EEy1t2uMTOfWs2DCW+WcBygsRVKkvJm6nW6MGLa46gM0Ds+Yfp0enBXI1hZhcr9DzHz5w== dagomez@Daniels-MacBook-Air.local
EOF

  ipconfig0 = "ip=192.168.1.200/24,gw=192.168.1.1"
  ipconfig1 = "ip=10.0.0.20/24"
}
