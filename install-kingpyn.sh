#!/bin/bash

sudo apt update
sudo apt install -y --no-install-recommends python-serial
sudo usermod -a -G dialout hms

mkdir workspace-pinball
pushd workspace-pinball
git init
git remote add -f origin https://github.com/spierepf/workspace-pinball.git
git config core.sparseCheckout true
echo "kingpyn" >> .git/info/sparse-checkout
git pull origin master
sudo cp kingpyn/udev/kingpyn.rules /etc/udev/rules.d
popd

pushd mpf/mpf/platform
rm -f kingpyn_platform.py
ln -s ../../../workspace-pinball/kingpyn/kingpyn_platform.py .
popd

echo workspace-pinball | sudo tee -a /opt/kiosk/directories
