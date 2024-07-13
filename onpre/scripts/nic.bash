#!/usr/bin/env bash

set -euo pipefail

: "$VPN_DOMAIN"

cat <<EOM

## Cofigure the vpn_vpnnic interface
EOM

rm -f /etc/network/interfaces.d/vpn_vpnnic

if (! grep 'up ip route add' /etc/network/interfaces); then
  VPN_IP="$(nslookup "$VPN_DOMAIN" | grep Address | awk '{print $2}' | tail -n 1)"
  MY_IP="$(ip addr show enp2s0 | grep inet | awk '{print $2}' | awk -F/ '{print $1}' | head -n 1)"
  sed -i "/iface vmbr0 inet static/a \\\tup ip route add $VPN_IP via $MY_IP" /etc/network/interfaces
  sed -i "/iface vmbr0 inet static/a \\\tup ip route add 192.168.133.0/24 via 172.16.168.1" /etc/network/interfaces
fi

if (! grep '# vpn_vpnnic settings' /etc/network/interfaces); then
  cat ./scripts/interfaces >> /etc/network/interfaces
  MY_IP="$(ip addr show enp2s0 | grep inet | awk '{print $2}' | awk -F/ '{print $1}' | head -n 1)"
  sed -i "/iface vmbr1 inet static/a \\\tup ip route add default via $MY_IP" /etc/network/interfaces
fi

ifdown vmbr0
ifup vmbr0
ifdown vmbr1
ifup vmbr1

systemctl restart networking

systemctl restart vpnclient

dhclient

cat <<EOM

## Try connecting to the VPN
EOM

for i in {1..10}; do
  if ip link show vpn_vpnnic &>/dev/null; then
    wget -q -O - httpbin.org/ip
    break
  fi
  sleep 1
  echo "Waiting for VPN connection... $i/10"
done

if ! ip link show vpn_vpnnic &>/dev/null; then
  echo "Failed to establish VPN connection"
  exit 1
fi

systemctl stop vpnclient
