#!/usr/bin/env bash

set -euo pipefail
START_TIME=$(date +%s)

PAIR_ID="${1:?Usage: rebuild-pair.sh <pair-number>}"

if ! [[ "${PAIR_ID}" =~ ^([1-9]|10)$ ]]; then
    echo "Pair number must be between 1 and 10"
    exit 1
fi

PAIR_NUMBER=$(printf "%02d" "${PAIR_ID}")

STUDENT_VM="student${PAIR_NUMBER}"
TARGET_VM="target${PAIR_NUMBER}"

cd /home/henrik/git/CyberRange/terraform

if ! terraform state list | grep -q \
"proxmox_virtual_environment_vm.vm\[\"${STUDENT_VM}\"\]"
then
    echo
    echo "ERROR: ${STUDENT_VM} is not currently deployed."
    exit 1
fi

if ! terraform state list | grep -q \
"proxmox_virtual_environment_vm.vm\[\"${TARGET_VM}\"\]"
then
    echo
    echo "ERROR: ${TARGET_VM} is not currently deployed."
    exit 1
fi

terraform apply \
  -auto-approve \
  -var-file=environments/demo.tfvars \
  -replace="proxmox_virtual_environment_vm.vm[\"${STUDENT_VM}\"]" \
  -replace="proxmox_virtual_environment_vm.vm[\"${TARGET_VM}\"]"

/home/henrik/git/CyberRange/scripts/cyberrange/update-monitoring.sh

cd /home/henrik/git/CyberRange/ansible

cd /home/henrik/git/CyberRange/ansible

ansible-playbook \
  playbooks/cyberrange/bootstrap.yml \
  --limit "${STUDENT_VM},${TARGET_VM}"

ansible-playbook \
  playbooks/cyberrange/firewall.yml \
  --limit "${STUDENT_VM},${TARGET_VM}"

ansible-playbook \
  playbooks/cyberrange/validation.yml \
  --limit "${STUDENT_VM},${TARGET_VM}"

END_TIME=$(date +%s)

DURATION=$((END_TIME - START_TIME))

MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo
echo "Pair rebuild completed successfully."
echo "Total runtime: ${MINUTES}m ${SECONDS}s"
