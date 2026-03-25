#!/bin/bash

current=$(hyprctl -j activeworkspace | jq -r '.id')
workspaces=8
dir=$1

if [[ "$dir" == "next" ]]; then
  move=$((current + 1))
  if (( move > workspaces )); then
    move=1
  fi
elif [[ "$dir" == "prev" ]]; then
  move=$((current - 1))
  if (( move < 1 )); then
    move=$workspaces
  fi
fi

hyprctl dispatch movetoworkspace $move
