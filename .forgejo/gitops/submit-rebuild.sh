#!/usr/bin/env bash

set -euo pipefail

VM_NAME="${1:?vm_name required}"

REQUEST_ID="$(date +%Y%m%d-%H%M%S)-${VM_NAME}"

cat > "/home/henrik/cyberrange-control/queue/${REQUEST_ID}.json" <<EOF
{
  "action": "rebuild-vm",
  "target": "${VM_NAME}"
}
EOF

echo "Queued rebuild request for ${VM_NAME}"
