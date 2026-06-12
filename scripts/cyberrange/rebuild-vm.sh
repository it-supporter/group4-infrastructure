#!/usr/bin/env bash

set -euo pipefail
START_TIME=$(date +%s)

VM_NAME="${1:?Usage: rebuild-vm.sh <vm-name>}"

if ! [[ "${VM_NAME}" =~ ^(student|target)(0[1-9]|10)$ ]]; then
    echo "Invalid VM name: ${VM_NAME}"
    exit 1
fi

cd /home/henrik/git/CyberRange/terraform

terraform apply \
  -auto-approve \
  -var-file=environments/demo.tfvars \
  -replace="proxmox_virtual_environment_vm.vm[\"${VM_NAME}\"]"

/home/henrik/git/CyberRange/scripts/cyberrange/update-monitoring.sh

cd /home/henrik/git/CyberRange/ansible

ansible-playbook \
  playbooks/cyberrange/bootstrap.yml \
  --limit "${VM_NAME}"

ansible-playbook \
  playbooks/cyberrange/firewall.yml \
  --limit "${VM_NAME}"

ansible-playbook \
  playbooks/cyberrange/validation.yml \
  --limit "${VM_NAME}"

END_TIME=$(date +%s)

DURATION=$((END_TIME - START_TIME))

MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo
echo "VM rebuild completed successfully."
echo "Total runtime: ${MINUTES}m ${SECONDS}s"
