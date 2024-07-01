#!/usr/bin/env bash
set -eo pipefail

if (($# == 1)); then
  VPN_DOMAIN=$1
elif [[ -z "$VPN_DOMAIN" ]]; then
  read -rp 'Please enter the VPN domain: ' VPN_DOMAIN
fi

mkdir -p /usr/local/bin/
cp dist/* /usr/local/bin/ || :

./scripts/install/setup_nic.sh "$VPN_DOMAIN"
