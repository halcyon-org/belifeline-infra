#!/bin/sh

if [ $# -gt 0 ]; then
  VPN_DOMAIN=$1
else
  if [ -z "$VPN_DOMAIN" ]; then
    read -p "Please enter the VPN domain: " VPN_DOMAIN
  fi
fi

(
    while true; do
        if ip link show vpn_vpnnic > /dev/null 2>&1; then
            ./scripts/install/_nic.sh $VPN_DOMAIN
            break
        fi
        sleep 1
    done
) &
NIC_SETUP_PID=$!

exec /usr/local/bin/vpnclient start

wait $NIC_SETUP_PID

exec /usr/local/bin/vpnclient start
