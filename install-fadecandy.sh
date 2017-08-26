#!/bin/bash

sudo apt update
sudo apt install -y --no-install-recommends git build-essential python

git clone https://github.com/scanlime/fadecandy.git
pushd fadecandy
git submodule update --init --recursive
popd

pushd fadecandy/server
make
popd

cat << EOF | sudo tee /etc/rc.local.d/fadecandy.sh
#!/bin/bash

/home/hms/fadecandy/server/fcserver &
EOF
