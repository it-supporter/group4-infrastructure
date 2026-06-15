#!/usr/bin/env bash
set -euo pipefail

cd /home/henrik/git/CyberRange/terraform

terraform "$@" -var-file=environments/demo.tfvars
