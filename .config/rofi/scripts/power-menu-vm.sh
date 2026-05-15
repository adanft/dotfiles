#!/bin/bash

theme="$HOME/.config/rofi/themes/power-menu.rasi"
confirm_theme="$HOME/.config/rofi/shared/confirm.rasi"

shutdown=''
reboot=''
lock=''
logout=''
yes=''
no=''

confirm() {
	[[ "$(printf '%s\n%s\n' "$yes" "$no" | rofi -dmenu -theme "$confirm_theme")" == "$yes" ]]
}

confirm_and_run() {
	confirm && "$@"
}

chosen="$(printf '%s\n%s\n%s\n%s\n' "$lock" "$logout" "$reboot" "$shutdown" | rofi -dmenu -theme "$theme")"

case "$chosen" in
	"$shutdown") confirm_and_run systemctl poweroff ;;
	"$reboot") confirm_and_run systemctl reboot ;;
	"$logout") confirm_and_run hyprctl dispatch 'hl.dsp.exit()' ;;
	"$lock") loginctl lock-session ;;
esac
