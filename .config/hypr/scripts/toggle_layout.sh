#!/bin/bash

current=$(hyprctl -j getoption general:layout | jq -r '.str')

if [[ "$current" == *"dwindle"* ]]; then
  hyprctl keyword general:layout master
else
  hyprctl keyword general:layout dwindle
fi
