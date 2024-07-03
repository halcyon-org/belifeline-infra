#!/usr/bin/env bash

set -euo pipefail

cat <<EOM


# proxmox.bash
EOM
./scripts/proxmox.bash

cat <<EOM


# network.bash
EOM
./scripts/network.bash

cat <<EOM


# vpn.bash
EOM
./scripts/vpn.bash

cat <<EOM


# nic.bash
EOM
./scripts/nic.bash
