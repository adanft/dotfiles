#!/bin/bash
set -euo pipefail

direction=${1:-}
current_workspace=${2:-}

if [[ "$direction" != "next" && "$direction" != "prev" ]]; then
  echo "Usage: $0 [next|prev] <current-workspace>" >&2
  exit 1
fi

if [[ ! "$current_workspace" =~ ^[0-9]+$ ]]; then
  echo "Invalid current workspace: $current_workspace" >&2
  exit 1
fi

active_monitor=$(hyprctl -j activeworkspace | jq -r '.monitor')
mapfile -t workspaces < <(
  hyprctl -j workspacerules |
    jq -r --arg monitor "$active_monitor" \
      '.[] | select(.monitor == $monitor) | .workspaceString | select(test("^[0-9]+$")) | tonumber' |
    sort -nu
)

if [[ ${#workspaces[@]} -eq 0 ]]; then
  mapfile -t workspaces < <(
    hyprctl -j workspacerules |
      jq -r '.[] | .workspaceString | select(test("^[0-9]+$")) | tonumber' |
      sort -nu
  )
fi

if [[ ${#workspaces[@]} -eq 0 ]]; then
  echo "No numeric workspaces are configured" >&2
  exit 1
fi

current_index=-1
for index in "${!workspaces[@]}"; do
  if [[ ${workspaces[$index]} -eq $current_workspace ]]; then
    current_index=$index
    break
  fi
done

if [[ $current_index -eq -1 ]]; then
  echo "Workspace $current_workspace is not configured" >&2
  exit 1
fi

if [[ "$direction" == "next" ]]; then
  target_index=$(((current_index + 1) % ${#workspaces[@]}))
else
  target_index=$(((current_index - 1 + ${#workspaces[@]}) % ${#workspaces[@]}))
fi

printf '%s\n' "${workspaces[$target_index]}"
