#!/bin/sh

ip addr add $ip/$mask dev $interface
if [ "$router" ]; then
  ip route add default via $router dev $interface
fi

if [ "$ip" ]; then
  echo -e "DHCP configuration for device $interface"
  echo -e "IP:     \\e[1m$ip\\e[0m"
  echo -e "MASK:   \\e[1m$mask\\e[0m"
  echo -e "ROUTER: \\e[1m$router\\e[0m"
fi