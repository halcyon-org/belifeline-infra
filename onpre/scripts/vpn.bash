#!/usr/bin/env bash

set -euo pipefail

: "$VPN_DOMAIN"
export PATH="/usr/local/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/bin/"

declare -A host_mac_dict=(
        ["souzou08"]="5e:ae:00:00:00:01"
        ["souzou03"]="5e:ae:00:00:00:02"
        ["souzou04"]="5e:ae:00:00:00:03"
        ["souzou05"]="5e:ae:00:00:00:04"
)

if [ -z "${host_mac_dict["$HOSTNAME"]}" ]; then
    cat <<EOM
Unknown hostname.
The mac address does not exist in dict.
EOM
    exit 1
fi

host_mac="${host_mac_dict["$HOSTNAME"]}"

cat <<EOM

## Copy the VPN commands
EOM

mkdir -p /usr/local/bin/
cp dist/* /usr/local/bin/ || :

cp scripts/vpnclient.service /etc/systemd/system/vpnclient.service
systemctl daemon-reload
systemctl enable vpnclient

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

if (! vpncmd /CLIENT localhost /CMD NicList | grep 'VPNNIC'); then
  vpncmd /CLIENT localhost /CMD NicCreate VPNNIC
  vpncmd /CLIENT localhost /CMD NicSetSetting VPNNIC /MAC:"$host_mac"
  systemctl restart vpnclient
fi

if (! vpncmd /CLIENT localhost /CMD AccountGet vpn_connection); then
  vpncmd /CLIENT localhost /CMD AccountCreate vpn_connection /SERVER:"$VPN_DOMAIN":443 /USERNAME:"$HOSTNAME" /HUB:VPN /NICNAME:VPNNIC
fi
if [[ -v VPN_PASSWORD ]]; then
  vpncmd /CLIENT localhost /CMD AccountPasswordSet vpn_connection /PASSWORD "$VPN_PASSWORD" /TYPE:standard
else
  vpncmd /CLIENT localhost /CMD AccountAnonymousSet vpn_connection
fi

if [[ -v ALL_PROXY ]]; then
  vpncmd /CLIENT localhost /CMD AccountProxyHttp vpn_connection /SERVER:"$(echo "$ALL_PROXY" | awk -F [:/] '{print $4":"$5}')"
fi

vpncmd /CLIENT localhost /CMD AccountStartupSet vpn_connection

vpncmd /CLIENT localhost /CMD AccountConnect vpn_connection
