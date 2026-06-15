#!/usr/bin/env bash

set -euo pipefail

scp \
/home/henrik/git/CyberRange/terraform/generated/demo-targets.yml \
henrik@monitor01:/home/henrik/monitoring/prometheus/demo-targets.yml

ssh henrik@monitor01 \
  "curl -s -X POST http://localhost:4010/-/reload"

echo
echo "Prometheus targets updated successfully."
