#!/usr/bin/env bash

set -euo pipefail

if (! ping -c 1 10.10.10.10 -W 1); then
  cat <<EOM

## Can't connect to 10.10.10.10
   Down and up the $DEFAULT_NIC
EOM

  ifdown "$DEFAULT_NIC"
  ifup "$DEFAULT_NIC"
fi

dhclient

if (ip a show "$DEFAULT_NIC" | grep -E '10\.[0-9]+\.[0-9]+\.[0-9]+'); then
  cat <<EOM

## Connect to the SNCT network
EOM

  read -rp 'SNCT network user name: ' NETWORK_USERNAME
  python3 scripts/snct-login.py "$NETWORK_USERNAME"
  while (ip a show "$DEFAULT_NIC" | grep -E '10\.[0-9]+\.[0-9]+\.[0-9]+'); do
    sleep 1
  done
fi
