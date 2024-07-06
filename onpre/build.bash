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
