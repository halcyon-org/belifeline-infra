#!/usr/bin/env bash

set -euo pipefail

cat <<EOM

## Modify APT repositories
EOM

rm -f /etc/apt/sources.list.d/{ceph,pve-enterprise}.list
if (! grep pve-no-subscription /etc/apt/sources.list); then
  cat >>/etc/apt/sources.list <<EOM

# Repositories for non-subscrIption
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription
EOM
fi

cat <<EOM

## Disable the Proxmox Enterprise popup
EOM

sed -i /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js -e 's/if (res === null/orig_cmd(); if (false) if (false/'
