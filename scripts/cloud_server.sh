#!/usr/bin/env bash

## Traffic going to the internet
route add default gw 10.2.0.1

## Save the iptables rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

## Install app
cd /home/vagrant/server_app
npm install

## Install wireguard
sudo apt-get install -y wireguard

## Generate keys
wg genkey | sudo tee /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
