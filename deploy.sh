#!/bin/bash
# --- CONFIGURACIÓN ---
PM_USER="root"
PM_HOST="192.168.1.69" # Reemplaza con la IP real de tu servidor Proxmox
VMS=("200" "201" "203")

echo "🧹 Limpiando infraestructura previa en Proxmox..."

for VM_ID in "${VMS[@]}"; do
    echo "⚡ Procesando VM $VM_ID..."
    # Parar la VM (ignoramos error si ya está parada)
    ssh $PM_USER@$PM_HOST "qm stop $VM_ID" 2>/dev/null
    # Eliminar la VM (ignoramos error si no existe)
    ssh $PM_USER@$PM_HOST "qm destroy $VM_ID --purge" 2>/dev/null
    echo "✅ VM $VM_ID eliminada."
done

echo "---------------------------------------"

echo "🚀 Creando infraestructura con Terraform..."
cd terraform && terraform apply -auto-approve

echo "⏳ Esperando 30s a que las VMs carguen el Cloud-Init..."
# Aumenté a 30s porque tras un borrado total el primer arranque suele tardar más
sleep 30

echo "🛠️ Configurando Laboratorio Completo con Ansible..."
cd ../ansible && ansible-playbook -i inventory.ini setup_node.yml --ask-become-pass 

echo "🏁 ¡Laboratorio listo y validado!"


