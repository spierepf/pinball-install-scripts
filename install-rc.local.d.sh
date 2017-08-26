#!/bin/bash

sudo mkdir /etc/rc.local.d

sudo mv /etc/rc.local /etc/rc.local.orig
cat << EOF | sudo tee /etc/rc.local
#!/bin/sh -e

for i in /etc/rc.local.d/*
do
    . \$i
done

exit 0
EOF
sudo chmod +x /etc/rc.local
