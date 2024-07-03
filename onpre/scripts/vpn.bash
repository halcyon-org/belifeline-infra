#!/usr/bin/env bash

set -euo pipefail

: "$VPN_USERNAME" "$VPN_PASSWORD" "$VPN_DOMAIN"
export PATH="/usr/local/bin:$PATH"

echo '## Copy the VPN commands'
mkdir -p /usr/local/bin/
cp dist/* /usr/local/bin/ || :

echo '## Create VPN settings'
vpncmd /CLIENT localhost /CMD NicCreate VPNNIC
vpncmd /CLIENT localhost /CMD AccountCreate vpn_connection /SERVER:"$VPN_DOMAIN":443 /USERNAME:"$VPN_USERNAME" /HUB:VPN /NICNAME:VPNNIC
vpncmd /CLIENT localhost /CMD AccountPasswordSet vpn_connection /PASSWORD "$VPN_PASSWORD" /TYPE:standard

if [[ -n "$ALL_PROXY" ]]; then
  vpncmd /CLIENT localhost /CMD AccountProxyHttp vpn_connection /SERVER:"$(echo "$ALL_PROXY" | awk -F [:/] '{print $4":"$5}')"
fi

vpncmd /CLIENT localhost /CMD AccountStartupSet vpn_connection
