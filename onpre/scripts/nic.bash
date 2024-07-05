#!/usr/bin/env bash

set -euo pipefail

: "$NIC" "$VPN_DOMAIN"
export PATH="/usr/local/bin:$PATH"

checknic() {
  dhclient "$NIC"
  MY_IP=$(ip addr show enp2s0 | grep inet | awk '{print $2}' | awk -F/ '{print $1}' | head -n 1)
  MY_GW=$(ip route | grep default | awk '{print $3}')
  MY_TOP_IP=$(echo "$MY_IP" | awk -F. '{print $1".0.0.0/8"}')
  VPN_IP=$(ip addr show vpn_vpnnic | grep inet | awk '{print $2}' | awk -F/ '{print $1}' | head -n 1)
  VPN_GW=$(echo "$VPN_IP" | awk -F. '{print $1"."$2"."$3".1"}')
  VPN_HOST=$(nslookup "$VPN_DOMAIN" | grep Address | awk '{print $2}' | tail -n 1)
  echo "My IP: $MY_IP"
  echo "My GW: $MY_GW"
  echo "VPN DOMAIN: $VPN_DOMAIN"
  echo "VPN HOST: $VPN_HOST"
  echo "VPN IP: $VPN_IP"
  echo "VPN GW: $VPN_GW"

  ip route add "$VPN_HOST" via "$MY_GW"
  ip route add "$MY_TOP_IP" via "$MY_GW"
  ip route del default
  ip route add default via "$VPN_GW"
  echo "nameserver $VPN_GW" >/etc/resolv.conf
}

cat <<EOM

## Copy the vpn_vpnnic interface
EOM

cat ./scripts/interfaces >/etc/network/interfaces.d/vpn_vpnnic

systemctl vpnclient restart

cat <<EOM

## Try connecting to the VPN
EOM

while true; do
  if ip link show vpn_vpnnic &>/dev/null; then
    checknic
    wget -q -O - httpbin.org/ip
    break
  fi
  sleep 1
done

systemctl vpnclient stop
