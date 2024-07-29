#!/usr/bin/env bash

set -euo pipefail

if [[ ! -v VPN_DOMAIN ]]; then
  export VPN_DOMAIN="magic.halcyon.cloud.shiron.dev"
fi

HOSTNAME=$(uname -n)
export HOSTNAME

cat <<EOM


# proxmox.bash
EOM
./scripts/proxmox.bash

cat <<EOM


# cron.bash
EOM
./scripts/cron.bash

cat <<EOM


# deps.bash
EOM
./scripts/deps.bash

cat <<EOM


# ansible.bash
EOM
./scripts/ansible.bash

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
