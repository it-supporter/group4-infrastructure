#!/usr/bin/env bash
set -euo pipefail

STATUS="/home/henrik/cyberrange-api/status/update-status.sh"

emit() {
  local system="$1"
  local state="$2"
  local message="$3"
  local target="${4:-}"

  $STATUS "$system" "$state" "$message" "$target"
}
