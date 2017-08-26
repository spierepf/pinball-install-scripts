#!/bin/bash

sudo mv /etc/network/interfaces /etc/network/interfaces.orig
cat <<EOF | sudo tee /etc/network/interfaces
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp

source /etc/network/interfaces.d/*
EOF

cat <<EOF | sudo tee /etc/network/interfaces.d/wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-ssid @ssid@
wpa-psk @psk@
EOF

sudo nano /etc/network/interfaces.d/wlan0
