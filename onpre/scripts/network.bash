#!/usr/bin/env bash

set -euo pipefail

dhclient enp2s0
if (ip a show enp2s0 | grep -E '172.16.2'); then
  ip route del default
  ip route add default via 172.16.200.1 dev vmbr0
fi

if (ip a show enp2s0 | grep -E '10\.[0-9]+\.[0-9]+\.[0-9]+'); then
  echo '## Connect to the SNCT network'
  read -rp 'SNCT network user name: ' NETWORK_USERNAME
  python3 scripts/setup/snct-login.py "$NETWORK_USERNAME"
  while (ip a show enp2s0 | grep -E '10\.[0-9]+\.[0-9]+\.[0-9]+'); do
    sleep 1
  done
fi
