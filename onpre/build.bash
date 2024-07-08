#!/usr/bin/env bash
set -euo pipefail

docker build sevpn -t debian-sevpn
docker run --detach --rm --name debian-sevpn debian-sevpn

mkdir -p dist
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN/build/vpnclient dist/
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN/build/vpncmd dist/
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN/build/hamcore.se2 dist/
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN/build/libcedar.so dist/
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN/build/libmayaqua.so dist/

docker stop debian-sevpn

mkdir -p dist/pkg
chmod a+wr dist/pkg
apt-get install apt-rdepends
readarray -t pkg_list < <(apt-rdepends libsodium-dev | grep -v "^ ")
(cd dist/pkg && apt-get download "${pkg_list[@]}")

if [ -d /mnt ]; then
  SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

  read -rp "Do you want to copy to /mnt? [y/N] " COPY_USB

  if [[ "$COPY_USB" =~ ^[yY]([eE][sS])?$ ]]; then
    cp -r "$SCRIPT_DIR"/../onpre /mnt/halcyon/belifeline-infra/
    echo "Copied to /mnt/halcyon/belifeline-infra/"
  else
    exit 0
  fi
fi
