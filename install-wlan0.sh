#!/bin/bash

DEVICE=`ifconfig -a | grep ^wlx | cut -d' ' -f1`

cat <<EOF | sudo tee /etc/network/interfaces.d/$DEVICE
allow-hotplug $DEVICE
iface $DEVICE inet dhcp
wpa-ssid @ssid@
wpa-psk @psk@
EOF

sudo nano /etc/network/interfaces.d/$DEVICE
