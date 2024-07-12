#!/usr/bin/env bash

set -euo pipefail

cat <<EOM

## Install dependencies
EOM

dpkg -i ./dist/pkg/*.deb
