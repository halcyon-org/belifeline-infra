#!/usr/bin/env bash

set -euo pipefail

cat <<EOM

## Modify APT repositories
EOM

rm -f /etc/apt/source.list.d/{ceph,pve-enterprise}.list
echo '# Repositories for non-subscrIption' \
  'deb http://download.proxmox.com/debian/pve ookworm pve-no-subscription' \
  'deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription' >>/etc/apt/source.list

cat <<EOM

## Disable the Proxmox Enterprise popup
EOM

sed -i /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js -e 's/if (res === null/orig_cmd(); if (false) if (false/'
