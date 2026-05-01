#!/usr/bin/env bash

WALLPAPER="$HOME/Wallpapers/910930.jpg"

pgrep -x polkit-gnome-authentication-agent-1 >/dev/null || \
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

pkill -x picom >/dev/null 2>&1
picom --config "$HOME/.config/picom/picom.conf" >/dev/null 2>&1 &

pkill -x dunst >/dev/null 2>&1
dunst -config "$HOME/.config/dunst/dunstrc" >/dev/null 2>&1 &

pgrep -x blueman-applet >/dev/null || blueman-applet >/dev/null 2>&1 &

feh --bg-fill "$WALLPAPER" &

# X11 screensaver and DPMS — disable auto timeouts, keep DPMS enabled for manual force off
xset s 0 0 noblank noexpose
xset dpms 0 0 0

# Idle daemon
pkill -x x11idle >/dev/null 2>&1
x11idle &
