#!/usr/bin/env bash

set -euo pipefail

./scripts/setup/proxmox.bash
./scripts/setup/network.bash
./scripts/setup/vpn.bash
