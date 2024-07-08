#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

USB=$(find /Volumes/* -maxdepth 0 -type d -not -path "/Volumes/Macintosh HD" | head -n 1)

read -rp "Do you want to copy to $USB? [y/N] " COPY_USB

if [[ "$COPY_USB" =~ ^[yY]([eE][sS])?$ ]]; then
  cp -r "$SCRIPT_DIR"/../onpre "$USB"/halcyon/belifeline-infra/
  echo "Copied to $USB/halcyon/belifeline-infra/"
else
  exit 0
fi
