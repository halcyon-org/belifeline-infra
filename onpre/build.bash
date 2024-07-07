#!/usr/bin/env bash
set -euo pipefail

docker build sevpn -t debian-sevpn
docker run --detach --rm --name debian-sevpn debian-sevpn

mkdir -p dist
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN/build/. dist
rm -rf dist/src
rm -rf dist/CMakeFiles

docker stop debian-sevpn

chmod a+wr dist/
cd dist && apt-get download libsodium-dev

