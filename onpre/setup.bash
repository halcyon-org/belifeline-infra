#!/usr/bin/env bash

set -euo pipefail

if [[ ! -v VPN_DOMAIN ]]; then
  export VPN_DOMAIN="magic.halcyon.cloud.shiron.dev"
fi
if [[ ! -v VPN_USERNAME ]]; then
  read -rp 'VPN user name: ' VPN_USERNAME
  export VPN_USERNAME
fi

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
