#!/usr/bin/env bash

set -euo pipefail

./scripts/setup/proxmox.bash
./scripts/setup/network.bash
export ALL_PROXY='http://http-p.srv.cc.suzuka-ct.ac.jp:8080'
export HTTP_PROXY="$ALL_PROXY" HTTPS_PROXY="$ALL_PROXY"
./scripts/setup/vpn.bash
