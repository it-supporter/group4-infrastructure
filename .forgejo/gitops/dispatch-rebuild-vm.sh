#!/usr/bin/env bash
set -euo pipefail

VM_NAME="${1:?vm_name required}"

QUEUE="/home/henrik/cyberrange-control/queue"
TS=$(date +%Y%m%d-%H%M%S)

cat > "${QUEUE}/${TS}-${VM_NAME}.json" <<EOF
{
  "action": "rebuild-vm",
  "target": "${VM_NAME}"
}
EOF

echo "Queued rebuild request for ${VM_NAME}"
