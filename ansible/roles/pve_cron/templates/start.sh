#!/bin/bash

set -euo pipefail

status=$(/usr/sbin/qm status "{{ MINFANA_VMID }}" | /usr/bin/awk -F " " '{print $2}')
if [ $status = "stopped" ] ; then
/usr/sbin/qm start "{{ MINFANA_VMID }}"
fi
