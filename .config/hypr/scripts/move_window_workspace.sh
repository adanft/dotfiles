#!/bin/bash
set -euo pipefail

dir=${1:-}
current_workspace=$(hyprctl -j activewindow | jq -r '.workspace.id')
target_workspace=$("$HOME/.config/hypr/scripts/get_adjacent_workspace.sh" "$dir" "$current_workspace")

hyprctl dispatch "hl.dsp.window.move({ workspace = $target_workspace })"
