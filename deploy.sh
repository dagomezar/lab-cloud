#!/bin/bash
echo "🚀 Creando infraestructura..."
cd terraform && terraform apply -auto-approve
echo "⏳ Esperando 20s a que el SO inicie..."
sleep 20
echo "🛠️ Configurando MinIO con Ansible..."
cd ../ansible && ansible-playbook -i inventory.ini setup_node.yml --ask-become-pass


