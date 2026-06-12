#!/usr/bin/env bash

set -euo pipefail
START_TIME=$(date +%s)

PAIR_COUNT="${1:?Usage: deploy.sh <pair-count>}"

if ! [[ "${PAIR_COUNT}" =~ ^([1-9]|10)$ ]]; then
    echo "Pair count must be between 1 and 10"
    exit 1
fi

cd /home/henrik/git/CyberRange/terraform

terraform apply \
  -auto-approve \
  -var-file=environments/demo.tfvars \
  -var="pair_count=${PAIR_COUNT}"

/home/henrik/git/CyberRange/scripts/cyberrange/update-monitoring.sh

cd /home/henrik/git/CyberRange/ansible

ansible-playbook playbooks/cyberrange/bootstrap.yml
ansible-playbook playbooks/cyberrange/firewall.yml
ansible-playbook playbooks/cyberrange/validation.yml

END_TIME=$(date +%s)

DURATION=$((END_TIME - START_TIME))

MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo
echo "Deployment completed successfully."
echo "Total runtime: ${MINUTES}m ${SECONDS}s"
