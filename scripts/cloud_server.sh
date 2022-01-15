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

## Generate the params file
privateKey=`sudo cat /etc/wireguard/private.key`
publicKey=`sudo cat /etc/wireguard/public.key`

cat << EOF > api_params.js
{
  module.exports = {
    deviceId: "$DEVICE_ID",
    overlayId: "$OVERLAY_ID",
    token: "$TOKEN",
    publicKey: "$publicKey",
  };
}
EOF

## Register public key in the API
node registerPublicKey.js

## Generate base Wireguard config file
cat << EOF > /etc/wireguard/wg0-base.conf
[Interface]
PrivateKey = $privateKey
ListenPort = 51820
SaveConfig = true
Address = $ADDRESS
EOF
