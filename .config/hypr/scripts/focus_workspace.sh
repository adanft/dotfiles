#!/bin/bash

current_workspace=$(hyprctl -j activeworkspace | jq -r '.id')

workspaces=9

dir=$1

if [[ "$dir" == "next" ]]; then
  target_workspace=$((current_workspace + 1))
  if [[ $target_workspace -gt $workspaces ]]; then
    target_workspace=1
  fi
elif [[ "$dir" == "prev" ]]; then
  target_workspace=$((current_workspace - 1))
  if [[ $target_workspace -lt 1 ]]; then
    target_workspace=$workspaces
  fi
else
  echo "Missing parameter: $0 [next|prev]"
  exit 1
fi

hyprctl dispatch "hl.dsp.focus({ workspace = $target_workspace })"
