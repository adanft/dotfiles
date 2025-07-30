#!/bin/bash

feh --bg-scale $HOME/Wallpapers/910930.jpg &

picom --config $HOME/.config/qtile/picom.conf &

dunst &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

blueman-applet &

xrdb ~/.Xresources &

xset s 300 &
xset dpms 330 &
xss-lock --transfer-sleep-lock -- $HOME/.config/qtile/lock &
