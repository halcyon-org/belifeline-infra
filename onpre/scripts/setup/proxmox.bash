#!/usr/bin/env bash

set -euo pipefail

echo '## Modify APT repositories'
rm -f /etc/apt/source.list.d/{ceph,pve-enterprise}.list
echo 'Repositories for non-subscrIption' \
  'deb http://download.proxmox.com/debian/pve ookworm pve-no-subscription' \
  'deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription' >>/etc/apt/source.list

echo '## Disable the Proxmox Enterprise popup'
sed -i /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js -e 's/if (res === null/orig_cmd(); if (false) if (false/'
