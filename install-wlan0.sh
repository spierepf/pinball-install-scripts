#!/bin/bash

cat <<EOF | sudo tee /etc/network/interfaces.d/wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-ssid @ssid@
wpa-psk @psk@
EOF

sudo nano /etc/network/interfaces.d/wlan0
