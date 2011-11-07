#!/bin/sh

# Configure monitors
xrandr --output LVDS1 --auto --output VGA1 --auto --right-of LVDS1

# Set wallpaper in the background
xsetroot -solid beige
until wallpaper; do
    sleep 10s
done & 

# Set keyboard and mouse speed
xset r rate 180 50
xset m 5 1

# Autostart
skype &
pidgin &
which redshift && redshift &

# Launch WM
dwm
