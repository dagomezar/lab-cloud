# 🚀 Lab Cloud: Automated S3 Storage Infrastructure (MinIO)

This repository contains the complete automation to deploy an S3-compatible object storage cluster (MinIO) over a virtualized infrastructure on **Proxmox**.

## 📝 Project Description
The project was developed within a local homelab running Proxmox VE. The goal is to create a private, scalable, and persistent object storage environment using Infrastructure as Code (IaC). This setup decouples the 'virtual hardware' provisioning (Terraform) from the software configuration and data volume management (Ansible).


---

## 🏗️ Technical Challenge
The main challenge involved **hybrid orchestration**:
1.  **Proxmox Provisioning:** Configuring a VM based on Ubuntu 24.04 (Cloud-Init) templates dynamically.
2.  **Storage Management:** Automating the detection, partitioning, and mounting of a dedicated secondary disk (15GB) for object data, ensuring persistence across reboots.
3.  **Dockerization:** Deploying MinIO within containers to facilitate future updates and process isolation.

---

## ⚡ Simulated Scenario
**Scenario:** "We need a development environment for database backups that does not rely on AWS S3 variable costs, while maintaining full API compatibility."

**Problems Solved:**
* **Shadow IT:** Avoids the use of personal public cloud accounts for sensitive data.
* **Manual Configuration:** Eliminates human error in installing Docker or manually configuring disks via SSH.
* **Persistence:** Solves the data loss issue by separating the OS from the MinIO data volume.

---

## 🛠️ Implemented Solution

The solution is divided into two main layers:

### 1. Infrastructure Layer (Terraform)
Located in `/terraform`, it handles:
* Connecting to the Proxmox API.
* Cloning the OS template.
* Injecting public SSH keys for passwordless access.
* Defining network and disk resources.

### 2. Configuration Layer (Ansible)
Located in `/ansible`, it handles:
* Installing system dependencies and Docker.
* Formatting the `/dev/sdb` disk with the `ext4` file system.
* Persistently mounting the disk at `/mnt/data` via `/etc/fstab`.
* Deploying the MinIO container with mapped volumes.

---

## 🚀 How to Deploy

1. **Clone the repo:** `git clone https://github.com/dagomezar/lab-cloud.git`
2. **Infrastructure:**
   ```bash
   cd terraform
   terraform init
   terraform apply
3. **Configuration:
   cd ../ansible
   ansible-playbook -i inventory.ini setup_node.yml --ask-become-pass





