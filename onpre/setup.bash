#!/usr/bin/env bash

set -euo pipefail

./setup/proxmox.bash
./setup/network.bash
./setup/vpn.bash
