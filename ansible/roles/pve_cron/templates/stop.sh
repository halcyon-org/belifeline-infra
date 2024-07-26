#!/bin/bash

set -euo pipefail

status=$(/usr/sbin/qm status "{{ MINFANA_VMID }}" | /usr/bin/awk -F " " '{print $2}')
if [ $status = "running" ] ; then
/usr/sbin/qm stop "{{ MINFANA_VMID }}"
fi
