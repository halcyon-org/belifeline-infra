#!/bin/sh
set -e

VPN_DOMAIN=vpn.example.com

mkdir -p /usr/local/bin/
cp dist/* /usr/local/bin/

./scripts/install/setup_nic.sh $VPN_DOMAIN
