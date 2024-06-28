#!/usr/bin/env bash

set -euo pipefail

if (ip a show enp2s0 | grep -E '10\.[0-9]+\.[0-9]+\.[0-9]+'); then
  echo '## Connect to the SNCT network'
  read -rp 'SNCT network user name: ' NETWORK_USERNAME
  python3 scripts/setup/snct-login.py "$NETWORK_USERNAME"
  export ALL_PROXY='http://http-p.srv.cc.suzuka-ct.ac.jp:8080'
  export HTTP_PROXY="$ALL_PROXY" HTTPS_PROXY="$ALL_PROXY"
fi
