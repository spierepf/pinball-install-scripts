#!/bin/bash

if [ ! -f /etc/network/interfaces.orig ]
then
    sudo mv /etc/network/interfaces /etc/network/interfaces.orig
fi

head -n4 /etc/network/interfaces.orig | sudo tee /etc/network/interfaces
head -n8 /etc/network/interfaces.orig | tail -n3 | sudo tee /etc/network/interfaces.d/lo
tail -n3 /etc/network/interfaces.orig | sudo tee /etc/network/interfaces.d/ens3

sudo sed -i s/auto/allow-hotplug/ /etc/network/interfaces.d/ens3
