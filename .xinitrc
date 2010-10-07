#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# Disable touchpad clicks while typing
syndaemon -k -t -i 1 > /dev/null &

# modmap
if [ -f ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

#urxvt daemon
urxvtd -q -f -o

# speed up keyboard repetition rate
xset r rate 200 30 &

dwm() {
    # Random wallpaper
    find $HOME/.wallpaper -type f -regex '.*\.\(jpg\|png\)' | shuf -n 1 | xargs bgs

    dwmstatus -l & 

    exec dwm
}

# Launch DE
# exec gnome-session
# exec awesome
#exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
# exec xterm
# exec wmii
dwm
