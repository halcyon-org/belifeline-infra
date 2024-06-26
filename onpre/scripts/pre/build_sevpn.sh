#!/bin/sh

docker build sevpn -t debian-sevpn
docker run --detach --rm --name debian-sevpn debian-sevpn

mkdir dist
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN_Stable/bin/vpnclient/vpnclient dist/
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN_Stable/bin/vpncmd/vpncmd dist/
docker cp debian-sevpn:/usr/local/src/SoftEtherVPN_Stable/bin/vpnclient/hamcore.se2 dist/

docker stop debian-sevpn
