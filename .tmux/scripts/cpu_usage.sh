#!/bin/sh

set -eu

PROC_STAT='/proc/stat'
SAMPLE_DELAY='0.2'

print_unknown() {
    printf 'CPU ?%%\n'
}

read_cpu_totals() {
    [ -r "$PROC_STAT" ] || return 1

    IFS=' ' read -r _ user nice system idle iowait irq softirq steal guest guest_nice < "$PROC_STAT" || return 1

    : "${user:=0}" "${nice:=0}" "${system:=0}" "${idle:=0}" "${iowait:=0}" \
      "${irq:=0}" "${softirq:=0}" "${steal:=0}" "${guest:=0}" "${guest_nice:=0}"

    total=$((user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice))
    idle_all=$((idle + iowait))

    printf '%s %s\n' "$total" "$idle_all"
}

first_sample=$(read_cpu_totals 2>/dev/null) || {
    print_unknown
    exit 0
}

sleep "$SAMPLE_DELAY"

second_sample=$(read_cpu_totals 2>/dev/null) || {
    print_unknown
    exit 0
}

set -- $first_sample
total_1=$1
idle_1=$2

set -- $second_sample
total_2=$1
idle_2=$2

total_delta=$((total_2 - total_1))
idle_delta=$((idle_2 - idle_1))

if [ "$total_delta" -le 0 ]; then
    print_unknown
    exit 0
fi

usage=$(((100 * (total_delta - idle_delta)) / total_delta))

if [ "$usage" -lt 0 ]; then
    usage=0
elif [ "$usage" -gt 100 ]; then
    usage=100
fi

printf 'CPU %s%%\n' "$usage"
