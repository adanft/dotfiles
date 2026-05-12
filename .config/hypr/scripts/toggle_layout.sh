#!/bin/bash

current=$(hyprctl -j getoption general:layout | jq -r '.str')

if [[ "$current" == *"dwindle"* ]]; then
  hyprctl eval 'hl.config({ general = { layout = "master" } })'
else
  hyprctl eval 'hl.config({ general = { layout = "dwindle" } })'
fi
