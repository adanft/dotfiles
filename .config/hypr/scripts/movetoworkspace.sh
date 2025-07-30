#!/bin/bash

current_workspace=$(hyprctl activeworkspace | grep 'workspace ID' | awk '{print $3}')

workspaces=8

dir=$1

if [[ "$dir" == "next" ]]; then
  move_workspace=$((current_workspace + 1))
  if [[ $move_workspace -gt $workspaces ]]; then
    move_workspace=1
  fi
elif [[ "$dir" == "prev" ]]; then
  move_workspace=$((current_workspace - 1))
  if [[ $move_workspace -lt 1 ]]; then
    move_workspace=$workspaces
  fi
else
  echo "Missing parameter: $0 [next|prev]"
fi

hyprctl dispatch workspace $move_workspace
