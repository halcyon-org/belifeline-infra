#!/usr/bin/env bash

set -euo pipefail

cat <<EOM

## Cofigure the vpn_vpnnic interface
EOM

rm -f /etc/network/interfaces.d/vpn_vpnnic

cp -i ./scripts/interfaces/"$HOSTNAME" /etc/network/interfaces

cat <<EOM

### Reload interfaces
EOM

systemctl start vpnclient
ifreload -a

cat <<EOM

### Restart networking
EOM

systemctl restart networking

cat <<EOM

## Try connecting to the VPN
EOM

for i in {1..10}; do
  if res=$(wget -q -O - httpbin.org/ip)
  then
    echo "$res"
    break
  elif [[ $i -eq 10 ]]; then
    echo "Failed to connect to VPN"
    exit 1
  fi
  sleep 1
  echo "Waiting for VPN connection... $i/10"
done
