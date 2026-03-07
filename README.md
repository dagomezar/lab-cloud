# 🚀 Lab Cloud: Automated DBRE Infrastructure (PostgreSQL & MinIO)

This repository contains the complete automation to deploy a hybrid data ecosystem: an S3-compatible object storage cluster (**MinIO**) and an optimized **PostgreSQL** database node, all running on **Proxmox VE** via Infrastructure as Code (IaC).

## 🏗️ Technical Architecture

The infrastructure consists of two specialized nodes managed as code:

- **VM 200 (MinIO Storage):** S3-compatible server for backups and objects. Runs Dockerized MinIO with a dedicated 15GB XFS volume for data persistence.
- **VM 201 (PostgreSQL Legacy):** Bare-metal PostgreSQL 16 node. Optimized for high-performance workloads with 8GB of RAM and tuned memory parameters.
- **Network:** Private lab network (192.168.1.0/24) with passwordless SSH access via Cloud-Init.

---

## 🏗️ Technical Challenge
The main challenge involved **hybrid orchestration and DBRE principles**:
1. **Proxmox Provisioning:** Dynamic VM creation based on Ubuntu 24.04 Cloud-Init templates using Terraform.
2. **Storage Management:** Automating detection, partitioning (XFS), and mounting of secondary disks for persistence.
3. **Database Tuning:** Configuring a "bare-metal" Postgres instance to utilize 8GB of RAM effectively (moving away from default restricted settings).
4. **Backup Pipeline:** Implementing a streaming backup strategy from PostgreSQL to S3 (MinIO) without local disk overhead.

---

## ⚡ Simulated Scenario
**Scenario:** "We need a development environment for database backups that does not rely on public cloud costs, while maintaining full S3 API compatibility and a high-performance database instance."

**Problems Solved:**
* **Shadow IT:** Avoids using personal public cloud accounts for sensitive database backups.
* **Manual Configuration:** Eliminates human error in installing Docker or tuning `postgresql.conf` manually.
* **Persistence:** Decouples the OS from data volumes (S3) and ensures DB settings persist via `ALTER SYSTEM`.

---

## 🛠️ Implemented Solution

### 1. Infrastructure Layer (Terraform)
Located in `/terraform`, it handles:
* Connecting to the Proxmox API and cloning OS templates.
* Injecting public SSH keys for secure access.
* Defining virtual hardware (CPU, RAM, Disks) for both Storage and DB nodes.

### 2. Configuration Layer (Ansible)
Located in `/ansible`, it handles:
* **Storage Node (.200):** * Formatting `/dev/sdb` as XFS and mounting it to `/mnt/data`.
    * Deploying MinIO via Docker with mapped volumes.
* **Database Node (.201):** * Installation of PostgreSQL 16.
    * **Performance Tuning:** Automated memory optimization (`shared_buffers = 2GB`, `effective_cache_size = 6GB`).
    * **Remote Access:** Configuring `pg_hba.conf` and listeners for local network access.
    * **Disaster Recovery:** Automated Cron job (02:00 AM) that streams `pg_dumpall` directly to the MinIO S3 bucket using `mc pipe`.

---

## 🚀 How to Deploy

1. **Clone the repo:** ```bash
   git clone [https://github.com/dagomezar/lab-cloud.git](https://github.com/dagomezar/lab-cloud.git)

2. **Provision Infrastructure:
   cd terraform
   terraform init
   terraform apply

3. **Configure Nodes:
   cd ../ansible
   ansible-playbook -i inventory.ini setup_node.yml --ask-become-pass


## 🔍Verification & DBRE Checks
   Verify the database optimization:

   # Check shared memory (Should return 2GB)
   sudo -u postgres psql -c "SHOW shared_buffers;"

   # Verify MinIO connectivity from the DB node
   sudo -u postgres mc ls lab-s3/db-backups

📋 Requirements
   Proxmox VE 7.x/8.x.
   
   Ubuntu 24.04 Cloud Image (Template).
   
   Terraform & Ansible installed on the control machine (Mac/Linux).














