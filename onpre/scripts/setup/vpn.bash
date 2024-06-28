#!/usr/bin/env bash

# set -euo pipefail

if [[ -z "$VPN_PASSWORD" ]]; then
  echo 'Password for VPN is not set'
  exit 1
fi

export PATH="/usr/local/bin:$PATH"

echo '## Create VPN settings'
vpncmd /CLIENT localhost /CMD NicCreate VPNNIC
vpncmd /CLIENT localhost /CMD AccountCreate vpn_connection /SERVER:magic.halcyon.cloud.shiron.dev:443 /USERNAME:pve01 /HUB:VPN /NICNAME:VPNNIC
vpncmd /CLIENT localhost /CMD AccountPasswordSet vpn_connection /PASSWORD "$VPN_PASSWORD" /TYPE:standard

if [[ -n "$ALL_PROXY" ]]; then
  vpncmd /CLIENT localhost /CMD AccountProxyHttp vpn_connection /SERVER:"$(echo "$ALL_PROXY" | awk -F [:/] '{print $4":"$5}')"
fi
