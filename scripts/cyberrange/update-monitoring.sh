#!/usr/bin/env bash

set -euo pipefail

scp \
/home/henrik/git/CyberRange/terraform/generated/demo-targets.yml \
henrik@monitor01:/home/henrik/monitoring/prometheus/demo-targets.yml

ssh henrik@monitor01 \
  "docker restart prometheus"

echo
echo "Prometheus targets updated successfully."
