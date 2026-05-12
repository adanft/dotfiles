#!/usr/bin/bash

theme="$HOME/.config/rofi/themes/screenshot.rasi"
icon="$HOME/.local/share/icons/candy-icons/apps/scalable/kscreensaver.svg"
time_icon="$HOME/.local/share/icons/candy-icons/apps/scalable/ktimer.svg"
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="screenshot_$(date +%Y-%m-%d-%H-%M-%S).png"

screen='󰍹'
area='󱓺'
window=''
delay5=''
delay10=''

mkdir -p "$dir"

notify_view() {
	local path="$dir/$file"

	if [[ -e "$path" ]]; then
		if command -v imv >/dev/null 2>&1; then
			imv "$path" &
		elif command -v feh >/dev/null 2>&1; then
			feh "$path" &
		fi

		notify-send -u low -i "$icon" "Screenshot Copied and Saved."
	else
		notify-send -u low -i "$icon" "Screenshot Deleted."
	fi
}

copy_shot() {
	tee "$dir/$file" | wl-copy --type image/png
}

countdown() {
	for ((sec = $1; sec > 0; sec--)); do
		notify-send -t 1000 -i "$time_icon" "Taking shot in : $sec"
		sleep 1
	done
}

take_shot() {
	local geometry="$1"

	if [[ -n "$geometry" ]]; then
		grim -g "$geometry" -t png - | copy_shot
	else
		grim -t png - | copy_shot
	fi

	notify_view
}

shot_window() {
	local geometry
	geometry="$(hyprctl activewindow -j | jq -r 'select(.at != null and .size != null) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"

	if [[ -n "$geometry" ]]; then
		sleep 0.5
		take_shot "$geometry"
	else
		notify-send -t 3000 "  No active window found"
	fi
}

shot_area() {
	local geometry
	geometry="$(slurp)"

	if [[ -n "$geometry" ]]; then
		take_shot "$geometry"
	else
		notify-send -t 3000 "󰜺  Screenshot cancelled"
	fi
}

chosen="$(printf '%s\n%s\n%s\n%s\n%s\n' "$screen" "$area" "$window" "$delay5" "$delay10" | rofi -dmenu -theme "$theme")"

case "$chosen" in
	"$screen") sleep 0.5; take_shot ;;
	"$area") shot_area ;;
	"$window") shot_window ;;
	"$delay5") countdown 5; sleep 1; take_shot ;;
	"$delay10") countdown 10; sleep 1; take_shot ;;
esac
