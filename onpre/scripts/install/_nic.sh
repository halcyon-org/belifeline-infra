#!/bin/sh
set -e

dhclient vpn_vpnnic

MY_IP=$(ip addr show eth0 | grep inet | awk '{print $2}' | awk -F/ '{print $1}' | head -n 1)
MY_GW=$(ip route | grep default | awk '{print $3}')
MY_TOP_IP=$(echo $MY_IP | awk -F. '{print $1".0.0.0/8"}')
VPN_IP=$(ip addr show vpn_vpnnic | grep inet | awk '{print $2}' | awk -F/ '{print $1}' | head -n 1)
VPN_GW=$( echo $VPN_IP | awk -F. '{print $1"."$2"."$3".1"}')
VPN_HOST=$( nslookup $VPN_DOMAIN | grep Address | awk '{print $2}' | tail -n 1)
echo "My IP: $MY_IP"
echo "My GW: $MY_GW"
echo "VPN DOMAIN: $VPN_DOMAIN"
echo "VPN HOST: $VPN_HOST"
echo "VPN IP: $VPN_IP"
echo "VPN GW: $VPN_GW"

ip route add $VPN_HOST via $MY_GW
ip route add $MY_TOP_IP via $MY_GW
ip route del default
ip route add default via $VPN_GW
echo "nameserver $VPN_GW" > /etc/resolv.conf

wget -q -O - httpbin.org/ip
