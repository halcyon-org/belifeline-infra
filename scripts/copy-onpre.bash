#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

USB=$(find /Volumes/* -maxdepth 0 -type d -not -path "/Volumes/Macintosh HD" | head -n 1)

if [ -z "$USB" ]; then
  echo "USB not found"
  read -rp "Host name of the on-premise pve(souzou0x): " PVE_NAME
  if [ -n "$PVE_NAME" ]; then
    rsync -av --update "$SCRIPT_DIR"/../onpre/ "root@$PVE_NAME":/root/onpre/
    echo "Copied to $PVE_NAME:/root/onpre/"
  else
    echo "No PVE_NAME provided"
    exit 0
  fi
else 
  read -rp "Do you want to copy to $USB? [Y/n] " COPY_USB

  if [[ "$COPY_USB" =~ ^[nN]([oO])?$ ]]; then
    exit 0
  else
    rsync -av --update "$SCRIPT_DIR"/../onpre/ "$USB"/halcyon/belifeline-infra/
    echo "Copied to $USB/halcyon/belifeline-infra/"
  fi
fi
