#!/usr/bin/bash

theme="$HOME/.config/rofi/themes/screenshot.rasi"
icon="$HOME/.local/share/icons/candy-icons/apps/scalable/kscreensaver.svg"
time_icon="$HOME/.local/share/icons/candy-icons/apps/scalable/ktimer.svg"

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
	xclip -selection clipboard -t image/png < "$file"
}

countdown() {
	for sec in `seq $1 -1 1`; do
		notify-send -t 1000 -i "$time_icon" "Taking shot in : $sec"
		sleep 1
	done
}

shotnow() {
	cd ${dir} && scrot -q 100 "$file" && copy_shot
	notify_view
}

shot5() {
	countdown '5'
	sleep 1 && cd ${dir} && scrot -q 100 "$file" && copy_shot
	notify_view
}

shot10() {
	countdown '10'
	sleep 1 && cd ${dir} && scrot -q 100 "$file" && copy_shot
	notify_view
}

shotwin() {
	cd ${dir} && scrot -u -q 100 "$file" && copy_shot
	notify_view
}

shotarea() {
	cd ${dir} && scrot -s -q 100 "$file" && copy_shot
	notify_view
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
