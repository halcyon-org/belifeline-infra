#!/usr/bin/env bash

set -euo pipefail

cat <<EOM

## Install dependencies
EOM

packages=("libsodium-dev")

for pkg in "${packages[@]}"
do
    if ( dpkg -l | grep -q "$pkg" ); then
        echo "$pkg is not installed. Installing..."
        dpkg -i ./dist/pkg/*.deb
        break
    else
        echo "$pkg is already installed."
    fi
done
