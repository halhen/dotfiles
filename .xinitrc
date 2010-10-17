#!/bin/sh
#
# #~/.xinitrc
#
# Shell script executed by xinit.
# Things that should start with X, including Window Managers and/or Desktop Environments goes here.
#
# I run a slightly customized [dwm](http://dwm.suckless.org), with the [pertag patch](http://dwm.suckless.org/patches/pertag) and modified keys. My setup is on [github](http://github.com/halhen/dwm).

# ## Settings
# Modify the keyboard.
if [ -f ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

# Speed up the keyboard repetition rate.
xset r rate 200 30 &

# ## Needed processes
# Start the rxvt-unicode daemon if needed.
pidof urxvtd || urxvtd -q -f -o

# ## dwm
# Function to launch dwm with other dwm specific processes.
#
# 1. Set a random wallpaper from ~/.wallpapers
# 2. Start the dwmstatus script, to update the statusline
# 3. Start dwm
#
# `exec dwm` converts the process to dwm, and keeps it and X alive as long as dwm is.
function _run_dwm {
    find $HOME/.wallpaper -type f -regex '.*\.\(jpg\|png\)' | shuf -n 1 | xargs bgs
    $HOME/.bin/dwmstatus -l & 
    exec dwm
}

# Finally, launch dwm.
_run_dwm
