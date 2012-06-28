#!/bin/sh

# Configure monitors
xrandr --output LVDS1 --auto --output $(xrandr | sed -n 's|^\(VGA.\).*|\1|p') --auto --left-of LVDS1

# Set wallpaper in the background
xsetroot -solid beige
until ~/.bin/wallpaper; do
    sleep 10s
done & 

# Set keyboard and mouse speed
xset r rate 180 50
xset m 5 1

# Some sanity for selections. Not much, but some.
which autocutsel && {
    autocutsel -fork &
    autocutsel -selection PRIMARY -fork &
}

# Autostart
skype &
pidgin &
which redshift && redshift &

# Launch WM
dwm
