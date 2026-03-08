#!/usr/bin/bash

theme="$HOME/.config/rofi/themes/screenshot.rasi"
icon="/usr/share/icons/candy-icons/apps/scalable/kscreensaver.svg"
time_icon="/usr/share/icons/candy-icons/apps/scalable/ktimer.svg"

option_1="󰍹"
option_2="󱓺"
option_3=""
option_4=""
option_5=""

rofi_cmd() {
	rofi -dmenu -theme ${theme}
}

run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

time=`date +%Y-%m-%d-%H-%M-%S`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="screenshot_${time}.png"

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

notify_view() {
	notify_cmd_shot="notify-send -u low -i $icon"
	
	if command -v imv >/dev/null 2>&1; then
		imv ${dir}/"$file" &
	elif command -v feh >/dev/null 2>&1; then
		feh ${dir}/"$file" &
	fi
	
	if [[ -e "$dir/$file" ]]; then
		${notify_cmd_shot} "Screenshot Copied and Saved."
	else
		${notify_cmd_shot} "Screenshot Deleted."
	fi
}

copy_shot() {
  tee "$file" | wl-copy --type image/png
}

countdown() {
	for sec in `seq $1 -1 1`; do
		notify-send -t 1000 -i "$time_icon" "Taking shot in : $sec"
		sleep 1
	done
}

shotnow() {
	cd ${dir} && sleep 0.5 && grim -t png - | copy_shot
	notify_view
}

shot5() {
	countdown '5'
	sleep 1 && cd ${dir} && grim -t png - | copy_shot
	notify_view
}

shot10() {
	countdown '10'
	sleep 1 && cd ${dir} && grim -t png - | copy_shot
	notify_view
}

shotwin() {
	local active_window=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
	
	if [[ "$active_window" != "null,null nullxnull" ]]; then
		sleep 0.5 && cd ${dir} && grim -g "$active_window" -t png - | copy_shot
		notify_view
	else
		notify-send -t 3000 "  No active window found"
	fi
}

shotarea() {
	local area=$(slurp)
	
	if [[ -n "$area" ]]; then
		cd ${dir} && grim -g "$area" -t png - | copy_shot
		notify_view
	else
		notify-send -t 3000 "󰜺  Screenshot cancelled"
	fi
}

run_cmd() {
	case "$1" in
		'--opt1')
			shotnow
			;;
		'--opt2')
			shotarea
			;;
		'--opt3')
			shotwin
			;;
		'--opt4')
			shot5
			;;
		'--opt5')
			shot10
			;;
	esac
}

chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac
