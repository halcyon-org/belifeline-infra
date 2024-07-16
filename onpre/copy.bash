#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

mkdir -p ~/onpre/
rsync -av --update "$SCRIPT_DIR"/../onpre/* ~/onpre/
