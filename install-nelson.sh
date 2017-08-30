#!/bin/bash

sudo apt update
sudo apt install -y --no-install-recommends git vorbis-tools normalize-audio

#mkdir workspace-pinball
#pushd workspace-pinball
#git init
#git remote add -f origin https://github.com/spierepf/workspace-pinball.git
#git config core.sparseCheckout true
#echo "kingpyn" >> .git/info/sparse-checkout
#git pull origin master
#popd

git clone https://github.com/spierepf/nelson2.git
pushd nelson2
git submodule update --init
python generate_shows.py
pushd sounds
git checkout master
git checkout .
for i in */*.ogg ; do normalize-ogg "$i" ; done
popd
popd

echo MACHINE=/home/hms/nelson2 | sudo tee /opt/kiosk/config
