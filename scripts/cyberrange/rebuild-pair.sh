#!/usr/bin/env bash

set -euo pipefail
START_TIME=$(date +%s)

STATUS="/home/henrik/cyberrange-api/status/update-status.sh"

PAIR_ID="${1:?Usage: rebuild-pair.sh <pair-number>}"

if ! [[ "${PAIR_ID}" =~ ^([1-9]|10)$ ]]; then
    echo "Pair number must be between 1 and 10"
    exit 1
fi

PAIR_NUMBER=$(printf "%02d" "${PAIR_ID}")

STUDENT_VM="student${PAIR_NUMBER}"
TARGET_VM="target${PAIR_NUMBER}"

cd /home/henrik/git/CyberRange/terraform

$STATUS rebuild-pair running "Terraform Replace" "$PAIR_NUMBER"

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

$STATUS rebuild-pair running "Updating Monitoring" "$PAIR_NUMBER"

/home/henrik/git/CyberRange/scripts/cyberrange/update-monitoring.sh

cd /home/henrik/git/CyberRange/ansible

$STATUS rebuild-pair running "Waiting For SSH" "$PAIR_NUMBER"

ansible-playbook \
  playbooks/cyberrange/bootstrap.yml \
  --limit "${STUDENT_VM},${TARGET_VM}"

$STATUS rebuild-pair running "Configuring Firewall" "$PAIR_NUMBER"

ansible-playbook \
  playbooks/cyberrange/firewall.yml \
  --limit "${STUDENT_VM},${TARGET_VM}"

$STATUS rebuild-pair running "Running Validation" "$PAIR_NUMBER"

ansible-playbook \
  playbooks/cyberrange/validation.yml \
  --limit "${STUDENT_VM},${TARGET_VM}"

END_TIME=$(date +%s)

DURATION=$((END_TIME - START_TIME))

MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

$STATUS rebuild-pair complete "Pair Rebuild Complete" "$PAIR_NUMBER"

echo
echo "Pair rebuild completed successfully."
echo "Total runtime: ${MINUTES}m ${SECONDS}s"
