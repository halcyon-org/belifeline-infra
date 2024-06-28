#!/bin/sh
set -e

if [ $# -gt 0 ]; then
  VPN_DOMAIN=$1
else
  if [ -z "$VPN_DOMAIN" ]; then
    read -p "Please enter the VPN domain: " VPN_DOMAIN
  fi
fi

mkdir -p /usr/local/bin/
cp dist/* /usr/local/bin/

./scripts/install/setup_nic.sh $VPN_DOMAIN
