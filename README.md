🚀 Lab Cloud: Automated DBRE & Analytics Infrastructure
This repository contains the complete automation to deploy a hybrid data ecosystem: an S3-compatible storage cluster, a PostgreSQL transactional node, and a Kubernetes-managed ClickHouse analytical cluster, all running on Proxmox VE via IaC.

🏗️ Technical Architecture
The infrastructure consists of three specialized nodes managed as code:

VM 200 (MinIO Storage): S3-compatible server for backups and objects. Runs Dockerized MinIO with a dedicated 15GB XFS volume.

VM 201 (PostgreSQL Legacy): Bare-metal PostgreSQL 16 node. Acts as the OLTP (Transactional) source with optimized memory parameters.

VM 203 (K8s Analytics): Kubernetes node (k3s/kubeadm) running the Altinity ClickHouse Operator. Acts as the OLAP (Analytical) engine.

Network: Private lab network (192.168.1.0/24).

🏗️ Technical Challenges & Solutions
Nested Virtualization (AMD): Enabled KVM nesting to allow the ClickHouse Pod to utilize high-performance CPU instructions within a virtualized K8s node.

LVM Thin Provisioning: Managed Proxmox storage exhaustion by dynamically extending LVM Thin Pools (pve/data) to prevent VM "IO Errors".

Data Federation: Configured ClickHouse to query PostgreSQL in real-time using the PostgreSQL engine, enabling cross-database joins without ETL overhead.

K8s Operator Pattern: Automated the lifecycle of ClickHouse clusters using a Custom Resource Definition (CHI).

⚡ Simulated Scenario
Scenario: "The company needs to perform real-time analytics on production PostgreSQL data without impacting its performance, utilizing a scalable Kubernetes environment for the analytical workload."

Problems Solved:

Data Silos: Connects Legacy SQL with Modern Analytics.

Resource Contention: Moves heavy analytical queries from Postgres to ClickHouse.

Infrastructure Scalability: Uses K8s to manage the analytical cluster growth.

🛠️ Implemented Solution
1. Infrastructure Layer (Terraform)
Handles the lifecycle of VMs in Proxmox, including:

Cloud-Init for user provisioning (dbre_admin) and SSH key injection.

Multi-disk setup: Specific volumes for OS and Data persistence.

2. Configuration & Orchestration (Ansible)
PostgreSQL Tuning (.201): Automated shared_buffers and effective_cache_size configuration based on VM RAM.

Kubernetes Analytics (.203):

Automated K8s node setup.

Deployment of the Altinity ClickHouse Operator.

Provisioning of a ClickHouseInstallation (CHI) and automatic creation of the Federated Database (pg_lab).

Health Check Suite: Final validation phase checking connectivity across all 3 nodes (MinIO, Postgres, K8s).

🚀 How to Deploy
Clone the repo:

Bash
git clone https://github.com/dagomezar/lab-cloud.git
Provision Infrastructure:

Bash
cd terraform && terraform init && terraform apply
Configure Everything (Full Stack):

Bash
cd ../ansible && ansible-playbook -i inventory.ini setup_node.yml
🔍 Verification & DBRE Checks
Federated Query Test (Postgres -> ClickHouse)
From the K8s node, verify you can see the Postgres data from ClickHouse:

Bash
kubectl exec -it -n sql-analitica svc/chi-lab-clickhouse-lab-cluster-0-0 -- clickhouse-client -q "SELECT * FROM pg_lab.productos_nombres LIMIT 5;"
Storage Health
Bash
# Check Proxmox Thin Pool status
lvs -a
🛠️ Troubleshooting (Lessons Learned)
No route to host (Terraform): Often caused by stale ARP cache or API proxy issues. Clear with sudo arp -d <IP> and restart pveproxy.

IO Error on VMs: Usually indicates the Proxmox Thin Pool is full. Extend with lvextend --extra 10G pve/data.

ClickHouse Pending Pods: Ensure the Proxmox VM has the "Host" CPU type enabled for nested virtualization support.

📋 Requirements
Proxmox VE 8.x with LVM-Thin storage.

Ubuntu 24.04 Cloud Image.

Ansible 2.15+ & Terraform 1.5+.













