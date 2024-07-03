#!/usr/bin/env bash

set -euo pipefail

if (! ping -c 1 10.10.10.10); then
  cat <<EOM

## Can't connect to 10.10.10.10
   Down and up the enp2s0
EOM

  ifdown enp2s0
  ifup enp2s0
fi

dhclient enp2s0

if (ip a show enp2s0 | grep -E '172.16.2'); then
  cat <<EOM

## Already connected to 172.16.2.n
EOM

  ip route del default
  ip route add default via 172.16.200.1 dev vmbr0
fi

if (ip a show enp2s0 | grep -E '10\.[0-9]+\.[0-9]+\.[0-9]+'); then
  cat <<EOM

## Connect to the SNCT network
EOM

  read -rp 'SNCT network user name: ' NETWORK_USERNAME
  python3 scripts/snct-login.py "$NETWORK_USERNAME"
  while (ip a show enp2s0 | grep -E '10\.[0-9]+\.[0-9]+\.[0-9]+'); do
    sleep 1
  done
fi
