#!/usr/bin/env bash

## Traffic going to the internet
route add default gw 172.30.30.1

## NAT
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

iptables -t nat -A PREROUTING -i enp0s8 -s 172.16.16.16 -j DNAT --to-destination 10.2.0.2
iptables -t nat -A PREROUTING -i enp0s8 -s 172.18.18.18 -j DNAT --to-destination 10.2.0.3

## Save the iptables rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6
