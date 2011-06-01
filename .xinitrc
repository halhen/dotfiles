#!/bin/sh
function start_dwm {
    xrandr --output LVDS1 --auto --output VGA1 --auto --right-of LVDS1
    xsetroot -solid beige
    xset r rate 180 50

    wicd-gtk &
    skype &
    pidgin &
    dwm
}

#pekwm
start_dwm

