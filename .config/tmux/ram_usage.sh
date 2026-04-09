#!/bin/sh

set -eu

PROC_MEMINFO='/proc/meminfo'

print_unknown() {
    printf 'RAM ?%%\n'
}

[ -r "$PROC_MEMINFO" ] || {
    print_unknown
    exit 0
}

mem_total=''
mem_available=''

while IFS=' ' read -r key value unit; do
    case "$key" in
        MemTotal:)
            mem_total=$value
            ;;
        MemAvailable:)
            mem_available=$value
            ;;
    esac

    if [ -n "$mem_total" ] && [ -n "$mem_available" ]; then
        break
    fi
done < "$PROC_MEMINFO"

case "$mem_total" in
    ''|*[!0-9]*)
        print_unknown
        exit 0
        ;;
esac

case "$mem_available" in
    ''|*[!0-9]*)
        print_unknown
        exit 0
        ;;
esac

if [ "$mem_total" -le 0 ]; then
    print_unknown
    exit 0
fi

used_pct=$(((100 * (mem_total - mem_available)) / mem_total))

if [ "$used_pct" -lt 0 ]; then
    used_pct=0
elif [ "$used_pct" -gt 100 ]; then
    used_pct=100
fi

printf 'RAM %s%%\n' "$used_pct"
