#!/bin/sh

set -eu

theme=$(dirname -- "$0")/../themes/dunst-history.rasi

for cmd in dunstctl jq rofi; do
    command -v "$cmd" >/dev/null 2>&1 || exit 1
done

tmp_dir=$(mktemp -d) || exit 1
menu_file="$tmp_dir/menu.tsv"
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

show_history_menu() {
    history_json=$(dunstctl history)
    : >"$menu_file"

    if [ "$(printf '%s\n' "$history_json" | jq '.data[0] | length')" -eq 0 ]; then
        printf 'info\t\t󰎟 No notification history\n' >"$menu_file"
    else
        printf 'clear\t\t󰆴 Clear history\n' >>"$menu_file"
        printf '%s\n' "$history_json" | jq -r '
            .data[0][]
            | [
                "entry",
                (.id.data | tostring),
                (
                    (if .urgency.data == "CRITICAL" then "󰀪" elif .urgency.data == "LOW" then "󰌶" else "󰂚" end)
                    + " "
                    + ((.summary.data // "No summary") | gsub("<[^>]+>"; "") | gsub("[[:space:]]+"; " ") | .[0:72])
                    + (if ((.body.data // "") | length) > 0 then " - " + ((.body.data // "") | gsub("<[^>]+>"; "") | gsub("[[:space:]]+"; " ") | .[0:112]) else "" end)
                    + "  ["
                    + ((.appname.data // "unknown") | gsub("[[:space:]]+"; " "))
                    + " #"
                    + (.id.data | tostring)
                    + "]"
                )
            ]
            | @tsv
        ' >>"$menu_file"
    fi

    cut -f3 "$menu_file" | rofi -theme "$theme" -dmenu -format i -mesg "Notifications 󰂚"
}

show_entry_actions() {
    entry_id=$1
    entry_label=$2

    action=$(
        printf '%s\n' "󰐃 Reopen notification" "󰆴 Delete selected entry" "󰜺 Back" \
            | rofi -theme "$theme" -dmenu -format i -p "History action" -mesg "$entry_label"
    )

    [ -n "$action" ] || return 1

    case "$action" in
        0)
            dunstctl history-pop "$entry_id" >/dev/null
            return 1
            ;;
        1)
            dunstctl history-rm "$entry_id" >/dev/null
            return 0
            ;;
        *)
            return 0
            ;;
    esac
}

show_clear_confirmation() {
    prompt=$1
    message=$2

    action=$(
        printf '%s\n' "󰆴 Confirm clear all" "󰜺 Back" \
            | rofi -theme "$theme" -dmenu -format i -p "$prompt" -mesg "$message"
    )

    [ -n "$action" ] || return 1
    [ "$action" -eq 0 ]
}

confirm_clear_history() {
    show_clear_confirmation "Clear history" "This action cannot be undone. Clear all notifications?"
}

while :; do
    selection=$(show_history_menu || true)
    [ -n "$selection" ] || exit 0

    record=$(awk -F '\t' -v selected_index="$selection" 'NR == selected_index + 1 { print; exit }' "$menu_file")
    [ -n "$record" ] || exit 0

    kind=$(printf '%s' "$record" | cut -f1)
    entry_id=$(printf '%s' "$record" | cut -f2)
    label=$(printf '%s' "$record" | cut -f3-)

    case "$kind" in
        clear)
            confirm_clear_history && dunstctl history-clear >/dev/null
            ;;
        entry)
            show_entry_actions "$entry_id" "$label" || exit 0
            ;;
        *)
            exit 0
            ;;
    esac
done
