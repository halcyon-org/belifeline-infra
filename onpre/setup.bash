#!/usr/bin/env bash

set -euo pipefail

DEFAULT_NIC=$(ip a | grep "master vmbr0" | awk '{print substr($2, 1 , length($2)-1)}')
export DEFAULT_NIC
echo "DEFAULT_NIC: $DEFAULT_NIC"

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
