#!/bin/bash

sudo add-apt-repository 'deb http://dl.google.com/linux/chrome/deb/ stable main'
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

sudo apt update
sudo apt install -y --no-install-recommends xorg openbox google-chrome-stable pulseaudio upstart-sysv xserver-xorg-legacy
sudo update-initramfs -u

sudo usermod -a -G audio $USER

cat << EOF | sudo tee /opt/kiosk.sh
#!/bin/bash

xset -dpms
xset s off
openbox-session &
start-pulseaudio-x11

while true; do
  rm -rf ~/.{config,cache}/google-chrome/
  google-chrome --kiosk --no-first-run  'http://thepcspy.com'
done
EOF
sudo chmod +x /opt/kiosk.sh

cat << EOF | sudo tee /etc/init/kiosk.conf
start on (filesystem and stopped udevtrigger)
stop on runlevel [06]

console output
emits starting-x

respawn

exec sudo -u $USER startx /etc/X11/Xsession /opt/kiosk.sh --
EOF

cat << EOF | sudo tee /etc/X11/Xwrapper.config
allowed_users=anybody
needs_root_rights=yes
EOF
