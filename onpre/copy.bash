#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

cp -r "$SCRIPT_DIR"/../onpre ~/
