#!/usr/bin/env bash

set -euo pipefail

./scripts/proxmox.bash
./scripts/network.bash
./scripts/vpn.bash
./scripts/nic.bash
