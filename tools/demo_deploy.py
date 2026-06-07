#!/usr/bin/env python3

import subprocess
import sys
from pathlib import Path

ROOT = Path.home() / "git" / "group4-infrastructure"

TERRAFORM_DIR = ROOT / "terraform-demo"
ANSIBLE_DIR = ROOT / "ansible"

INVENTORY = ANSIBLE_DIR / "inventories" / "demo" / "hosts.yml"

PLAYBOOK = ANSIBLE_DIR / "playbooks" / "demo_environment.yml"


def run(cmd, cwd=None):
    print(f"\n>>> {' '.join(cmd)}\n")

    result = subprocess.run(
        cmd,
        cwd=cwd,
        check=True
    )

    return result


def main():

    run(
        ["terraform", "apply", "-auto-approve"],
        cwd=TERRAFORM_DIR
    )

    run(
        [
            "ansible-playbook",
            "-i",
            str(INVENTORY),
            str(PLAYBOOK)
        ],
        cwd=ANSIBLE_DIR
    )

    print("\nDemo environment ready.\n")


if __name__ == "__main__":
    main()
