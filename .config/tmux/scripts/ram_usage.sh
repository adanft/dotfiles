#!/bin/sh

set -eu

PROC_MEMINFO='/proc/meminfo'

print_unknown() {
    printf 'RAM ?/? GB\n'
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

used_kb=$((mem_total - mem_available))

if [ "$used_kb" -lt 0 ]; then
    used_kb=0
fi

used_gb=$(((used_kb + 524288) / 1048576))
total_gb=$(((mem_total + 524288) / 1048576))

if [ "$used_gb" -lt 0 ]; then
    used_gb=0
fi

if [ "$total_gb" -lt 1 ]; then
    total_gb=1
fi

printf 'RAM %s/%s GB\n' "$used_gb" "$total_gb"
