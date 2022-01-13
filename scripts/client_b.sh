#!/usr/bin/env bash

## Traffic going to the internet
route add default gw 10.1.0.1

## Save the iptables rules
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

## Install app
cd /home/vagrant/client_app
npm install

cat << EOF > config.json
{
  "server_ip": "10.2.0.3",
  "server_port": "8080",
  "log_file": "/var/log/client.log"
}
EOF

## Install wireguard
sudo apt-get install -y wireguard

## Generate keys
wg genkey | sudo tee /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
