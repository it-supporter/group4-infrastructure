#!/usr/bin/env bash

set -euo pipefail
START_TIME=$(date +%s)
STATUS="/home/henrik/cyberrange-api/status/update-status.sh"

PAIR_COUNT="${1:?Usage: deploy.sh <pair-count>}"

if ! [[ "${PAIR_COUNT}" =~ ^([1-9]|10)$ ]]; then
    echo "Pair count must be between 1 and 10"
    exit 1
fi

cd /home/henrik/git/CyberRange/terraform

$STATUS deploy running "Terraform Apply"

terraform apply \
  -auto-approve \
  -var-file=environments/demo.tfvars \
  -var="pair_count=${PAIR_COUNT}"

$STATUS deploy running "Updating Monitoring"

/home/henrik/git/CyberRange/scripts/cyberrange/update-monitoring.sh

$STATUS deploy running "Waiting For SSH"

cd /home/henrik/git/CyberRange/ansible

ansible-playbook playbooks/cyberrange/bootstrap.yml
$STATUS deploy running "Configuring Firewall"
ansible-playbook playbooks/cyberrange/firewall.yml
$STATUS deploy running "Running Validation"
ansible-playbook playbooks/cyberrange/validation.yml

END_TIME=$(date +%s)

DURATION=$((END_TIME - START_TIME))

MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

$STATUS deploy complete "Deployment Complete"

echo
echo "Deployment completed successfully."
echo "Total runtime: ${MINUTES}m ${SECONDS}s"

