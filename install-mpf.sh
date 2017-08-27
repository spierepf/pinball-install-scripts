#!/bin/bash

sudo apt update
sudo apt install -y --no-install-recommends git pypy python-serial python-yaml python-pygame

sudo adduser $USER dialout

git clone https://github.com/missionpinball/mpf.git
pushd mpf
git checkout 0.21
popd

pushd mpf
patch -p1 << EOF
diff --git a/mpf.sh b/mpf.sh
index 6d0a9dc..5c88711 100755
--- a/mpf.sh
+++ b/mpf.sh
@@ -10,8 +10,8 @@
 # This code will launch mc in a new window and require you to switch windows
 # and Ctrl-C out of each
 
-x-terminal-emulator -e bash -c "python mc.py \$@"
-python mpf.py "\$@"
+#x-terminal-emulator -e bash -c "python mc.py \$@"
+#python mpf.py "\$@"
 
 # The line below will launch both processes in the same terminal window
 # with the output of BOTH processes going to the same window
@@ -20,5 +20,17 @@ python mpf.py "\$@"
 # the prompt. To use, comment out the two commands above and uncomment the 
 # line below.
 
-#python mc.py "\$@" & python mpf.py "\$@" && echo "Killed both processes"
+export PYTHONPATH=/usr/lib/python2.7/dist-packages
+
+mkdir logs
+pushd logs
+rm mc-last.log
+ln -s \`ls *mc* | sort | tail -1\` mc-last.log
+rm mpf-last.log
+ln -s -f \`ls *mpf* | sort | tail -1\` mpf-last.log
+popd
+
+python mc.py "\$@" &
+sleep 5
+pypy mpf.py "\$@" && echo "Killed both processes"
 
diff --git a/mpf/platform/openpixel.py b/mpf/platform/openpixel.py
index f9ac06f..6791c78 100644
--- a/mpf/platform/openpixel.py
+++ b/mpf/platform/openpixel.py
@@ -72,7 +72,7 @@ class OpenPixelLED(object):
         self.opc_client.add_pixel(self.channel, self.led)
 
     def color(self, color):
-        self.log.debug("Setting color: %s", color)
+        #self.log.debug("Setting color: %s", color)
         self.opc_client.set_pixel_color(self.channel, self.led, color)
 
 
diff --git a/mpf/system/events.py b/mpf/system/events.py
index 8dbf70f..3bdd3c4 100644
--- a/mpf/system/events.py
+++ b/mpf/system/events.py
@@ -505,10 +505,10 @@ class EventManager(object):
             self.log.debug("vvvv Finished event '%s'. Type: %s. Callback: %s. "
                            "Args: %s", event, ev_type, callback, kwargs)
 
-        if ev_type is 'queue' and not queue:
+        if ev_type == 'queue' and not queue:
             # If this was a queue event but there were no registered handlers,
             # then we need to do the callback now
-            callback(**kwargs)
+            self.callback_queue.append((callback, kwargs))
 
         elif queue and queue.is_empty():
             # If we had a queue event that had handlers and a queue was created
@@ -519,7 +519,7 @@ class EventManager(object):
 
             if queue.callback:
                 # if there's still a callback, that means it wasn't called yet
-                queue.callback(**kwargs)
+                self.callback_queue.append((queue.callback, kwargs))
 
         if callback and ev_type != 'queue':
             # For event types other than queue, we'll handle the callback here.
diff --git a/mpf/system/light_controller.py b/mpf/system/light_controller.py
index 8e18950..80e4a7d 100755
--- a/mpf/system/light_controller.py
+++ b/mpf/system/light_controller.py
@@ -142,7 +142,10 @@ class LightController(object):
         if show in self.machine.shows:
             self.machine.shows[show].play(priority=priority, **kwargs)
         else:  # assume it's a show object?
-            show.play(priority=priority, **kwargs)
+            if isinstance(show, basestring):
+                self.log.error("Missing show: {}".format(show))
+            else:
+                show.play(priority=priority, **kwargs)
 
         try:
             self.running_show_keys[kwargs['key']] = show
EOF
popd

cat << EOF | sudo tee /opt/kiosk.sh
#!/bin/bash

xset -dpms
xset s off
openbox-session &
start-pulseaudio-x11

amixer set Master unmute
amixer set Master 75%

MACHINE=demo_man
cd /home/hms/mpf

while true; do
  killall -9 python
  killall -9 pypy
  sudo nice -n -10 sudo -u hms ./mpf.sh \$MACHINE -x -v -V
done
EOF
