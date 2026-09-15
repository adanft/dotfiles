#!/bin/bash
set -euo pipefail

dir=${1:-}
current_workspace=$(hyprctl -j activeworkspace | jq -r '.id')
target_workspace=$("$HOME/.config/hypr/scripts/get_adjacent_workspace.sh" "$dir" "$current_workspace")

hyprctl dispatch "hl.dsp.focus({ workspace = $target_workspace })"
