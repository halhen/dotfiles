#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# Disable touchpad clicks while typing
syndaemon -k -t -i 1 > /dev/null &

# urxvt deamon
urxvtd -q -f -o

killall notification-daemon &> /dev/null
statnot & 

# Launch DE
# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
# exec xterm
exec ~/.dwm-run.sh
# exec wmii