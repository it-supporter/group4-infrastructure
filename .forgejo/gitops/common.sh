#!/usr/bin/env bash

set -euo pipefail

export CYBERRANGE_ROOT="/home/henrik/git/CyberRange"

export TERRAFORM_DIR="${CYBERRANGE_ROOT}/terraform"
export ANSIBLE_DIR="${CYBERRANGE_ROOT}/ansible"

export STATUS_SCRIPT="/home/henrik/cyberrange-api/status/update-status.sh"

cd "${CYBERRANGE_ROOT}"
