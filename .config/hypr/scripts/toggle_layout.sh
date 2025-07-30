#!/bin/bash

current=$(hyprctl getoption general:layout)

if echo "$current" | grep -q 'dwindle'; then
  hyprctl keyword general:layout master
else
  hyprctl keyword general:layout dwindle
fi
