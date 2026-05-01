#!/bin/sh

theme=$(dirname -- "$0")/../themes/dunst-context.rasi

input_file=$(mktemp) || exit 1
trap 'rm -f "$input_file"' EXIT HUP INT TERM

cat >"$input_file"

selection=$(
    awk '
        /^#/ {
            print " " substr($0, 2)
            next
        }
        /^[[:alpha:]][[:alnum:]+.-][[:alnum:]+.-]*:[^[:space:]].*/ {
            print " " $0
            next
        }
        { print }
    ' "$input_file" | rofi -theme "$theme" -dmenu -format i "$@"
)

[ -n "$selection" ] || exit 1

awk -v line_no="$selection" 'NR == line_no + 1 { print; exit }' "$input_file"
