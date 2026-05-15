#!/bin/bash

current_workspace=$(hyprctl -j activewindow | jq -r '.workspace.id')
workspaces=$(hyprctl -j workspacerules | jq '[.[] | .workspaceString | select(test("^[0-9]+$")) | tonumber] | max')

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

hyprctl dispatch "hl.dsp.window.move({ workspace = $target_workspace })"
