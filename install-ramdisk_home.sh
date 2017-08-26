#!/bin/bash

cat <<'EOF' | sudo tee /etc/init.d/ramdisk_home
#!/bin/sh
# kFreeBSD do not accept scripts as interpreters, using #!/bin/sh and sourcing.
if [ true != "$INIT_D_SCRIPT_SOURCED" ] ; then
    set "$0" "$@"; INIT_D_SCRIPT_SOURCED=true . /lib/init/init-d-script
fi
### BEGIN INIT INFO
# Provides:          ramdisk_home
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     S
# Default-Stop:      0 6
# Short-Description: Example initscript
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.  This example start a
#                    single forking daemon capable of writing a pid
#                    file.  To get other behavoirs, implemend
#                    do_start(), do_stop() or other functions to
#                    override the defaults in /lib/init/init-d-script.
### END INIT INFO

# Author: Peter-Frank Spierenburg <spierepf@hotmail.com>

case "$1" in
start)
    if [ ! -d /tmp/ramdisk ]
    then
        mkdir /tmp/ramdisk
        chmod 777 /tmp/ramdisk
        mount -t tmpfs tmpfs /tmp/ramdisk
        rsync -a /home /tmp/ramdisk --delete
        mount --bind /tmp/ramdisk/home /home
    fi
	;;

stop)
    if [ -d /tmp/ramdisk ]
    then
        umount /home
        rsync -a /tmp/ramdisk/home / --delete
        umount /tmp/ramdisk
        rm -rf /tmp/ramdisk
    fi
	;;

*)
	echo "Usage: /etc/init.d/ramdisk_home {start|stop}"
	exit 1
	;;
esac

exit 0
EOF

sudo chmod +x /etc/init.d/ramdisk_home

sudo update-rc.d ramdisk_home defaults 98 02
