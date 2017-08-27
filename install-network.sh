#!/bin/bash

mv /etc/network/interfaces /etc/network/interfaces.orig
head -n4 /etc/network/interfaces.orig > /etc/network/interfaces
head -n8 /etc/network/interfaces.orig | tail -n3 > /etc/network/interfaces.d/lo
tail -n3 /etc/network/interfaces.orig > /etc/network/interfaces.d/ens3

sed -i s/auto/allow-hotplug/ /etc/network/interfaces.d/ens3
