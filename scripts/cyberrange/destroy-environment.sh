#!/usr/bin/env bash

set -euo pipefail
START_TIME=$(date +%s)

if [[ "${1:-}" != "--force" ]]; then

    echo
    echo "WARNING: This will destroy ALL Cyber Range VMs."
    echo

    read -rp "Type DESTROY to continue: " CONFIRM

    if [[ "${CONFIRM}" != "DESTROY" ]]; then
        echo "Cancelled."
        exit 1
    fi
fi

cd /home/henrik/git/CyberRange/terraform

terraform apply \
  -auto-approve \
  -var-file=environments/demo.tfvars \
  -var="pair_count=0"

/home/henrik/git/CyberRange/scripts/cyberrange/update-monitoring.sh

END_TIME=$(date +%s)

DURATION=$((END_TIME - START_TIME))

MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo
echo "Environment destroyed successfully."
echo "Total runtime: ${MINUTES}m ${SECONDS}s"
