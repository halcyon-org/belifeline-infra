#!/usr/bin/env bash

set -eo pipefail

if (($# == 1)); then
  VPN_DOMAIN=$1
elif [[ -z "$VPN_DOMAIN" ]]; then
  read -rp 'Please enter the VPN domain: ' VPN_DOMAIN
fi

export PATH="/usr/local/bin:$PATH"

cat ./scripts/install/interfaces >/etc/network/interfaces.d/vpn_vpnnic
ifdown vpn_vpnnic
ifup vpn_vpnnic

(
  while true; do
    if ip link show vpn_vpnnic &>/dev/null; then
      ./scripts/install/_nic.sh "$VPN_DOMAIN"
      break
    fi
    sleep 1
  done
) &
NIC_SETUP_PID=$!

vpnclient stop
vpnclient start

wait $NIC_SETUP_PID

vpnclient stop
