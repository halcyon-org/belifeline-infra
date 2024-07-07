#!/usr/bin/env bash

set -euo pipefail

: "$VPN_USERNAME" "$VPN_PASSWORD" "$VPN_DOMAIN"
export PATH="/usr/local/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/bin/"

cat <<EOM

## Copy the VPN commands
EOM

systemctl stop vpnclient  || :

dpkg -i dist/*.deb

mkdir -p /usr/local/bin/
cp dist/vpnclient /usr/local/bin/
cp dist/vpncmd /usr/local/bin/
cp dist/hamcore.se2 /usr/local/bin/
cp dist/*.so /usr/local/bin/

cp scripts/vpnclient.service /etc/systemd/system/vpnclient.service
systemctl daemon-reload

cat <<EOM

## Create VPN settings
EOM

systemctl stop vpnclient
VPN_CONFIG='/usr/local/bin/vpn_client.config'
if [[ -f "$VPN_CONFIG" ]]; then
  read -rp 'Delete the config? [y/N] ' REMOVE_CONFIG
  if [[ "$REMOVE_CONFIG" =~ ^[yY]([eE][sS])?$ ]]; then
    rm "$VPN_CONFIG"
  fi
fi
systemctl start vpnclient

for retry_num in $(seq 1 10)
do
  vpncmd /CLIENT localhost /CMD NicCreate VPNNIC && break
  if [ "$retry_num" -eq 5 ]; then
    echo "Error: Could not connect to vpnclient"
  fi
  sleep 1
done

vpncmd /CLIENT localhost /CMD AccountCreate vpn_connection /SERVER:"$VPN_DOMAIN":443 /USERNAME:"$VPN_USERNAME" /HUB:VPN /NICNAME:VPNNIC
vpncmd /CLIENT localhost /CMD AccountPasswordSet vpn_connection /PASSWORD "$VPN_PASSWORD" /TYPE:standard

if [[ -v ALL_PROXY ]]; then
  vpncmd /CLIENT localhost /CMD AccountProxyHttp vpn_connection /SERVER:"$(echo "$ALL_PROXY" | awk -F [:/] '{print $4":"$5}')"
fi

vpncmd /CLIENT localhost /CMD AccountStartupSet vpn_connection
vpncmd /CLIENT localhost /CMD AccountConnect vpn_connection
