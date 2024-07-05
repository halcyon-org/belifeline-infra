#!/usr/bin/env bash
set -euo pipefail

docker build sevpn -t debian-sevpn
docker run --detach --rm --name debian-sevpn debian-sevpn

mkdir -p dist
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN/build/ dist/

docker stop debian-sevpn
