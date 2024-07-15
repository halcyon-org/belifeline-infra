#!/usr/bin/env bash

set -euo pipefail

: "$VPN_USERNAME"

cat <<EOM

## Cofigure the vpn_vpnnic interface
EOM

rm -f /etc/network/interfaces.d/vpn_vpnnic

cp -i ./scripts/interfaces/"$VPN_USERNAME" /etc/network/interfaces

cat <<EOM

### Down interfaces
EOM

ifdown vmbr0
ifdown vmbr1
ifdown enp2s0
systemctl stop vpnclient

cat <<EOM

### Up interfaces
EOM

ifup enp2s0
systemctl start vpnclient
ifup vmbr0
ifup vmbr1

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
