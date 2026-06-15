#!/usr/bin/env bash
set -euo pipefail

VM_NAME="${1:?vm_name required}"

source "$(dirname "$0")/lib/status.sh"

emit rebuild-vm running "Starting rebuild" "$VM_NAME"

emit rebuild-vm running "Executing Terraform + Ansible" "$VM_NAME"

/home/henrik/git/CyberRange/scripts/cyberrange/rebuild-vm.sh "${VM_NAME}"

emit rebuild-vm complete "Rebuild finished" "$VM_NAME"
