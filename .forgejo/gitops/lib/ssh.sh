#!/usr/bin/env bash
set -euo pipefail

HOST="henrik@10.4.10.50"

run_remote() {
  ssh \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o ConnectTimeout=10 \
    "$HOST" "$1"
}
