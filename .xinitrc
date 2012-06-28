#!/bin/sh

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

# Configure monitors
xrandr --output LVDS1 --auto --output $(xrandr | sed -n 's|^\(VGA.\).*|\1|p') --auto --left-of LVDS1 &>/dev/null

# Set wallpaper in the background
xsetroot -solid beige
until ~/.bin/wallpaper; do
    sleep 10s
done &

# Set keyboard and mouse speed
xset r rate 180 50
xset m 5 1

# Some sanity for selections. Not much, but some.
isavailable autocutsel && {
    autocutsel -fork &
    autocutsel -selection PRIMARY -fork &
}

# Autostart
isavailable skype && skype &
isavailable pidgin && pidgin &
isavailable redshift && redshift &

# Launch WM
dwm
