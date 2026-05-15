#!/usr/bin/env bash

detect_monitor_count() {
  if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    hyprctl monitors -j 2>/dev/null | jq 'length' 2>/dev/null && return 0
  fi

  if [[ -d /sys/class/drm ]]; then
    local count=0
    local status
    for status in /sys/class/drm/card*-*/status; do
      [[ -e "$status" ]] || continue
      # Use assignment instead of post-increment because `((count++))`
      # returns status 1 when count starts at 0, which trips `set -e`.
      [[ "$(<"$status")" == "connected" ]] && count=$((count + 1))
    done
    printf '%s\n' "$count"
    return 0
  fi

  printf '0\n'
}

detect_machine_profile() {
  if systemd-detect-virt --quiet 2>/dev/null; then
    printf 'vm\n'
    return 0
  fi

  if [[ -d /sys/class/power_supply ]] && compgen -G '/sys/class/power_supply/BAT*' >/dev/null; then
    printf 'laptop\n'
    return 0
  fi

  printf 'desktop\n'
}

detect_profile() {
  DETECTED_PROFILE="$(detect_machine_profile)"
  MONITOR_COUNT="$(detect_monitor_count)"
  SELECTED_PROFILE="$DETECTED_PROFILE"
}

confirm_profile() {
  log_info "Detected profile: ${DETECTED_PROFILE} (${MONITOR_COUNT} monitor(s))"

  local choice
  choice="$(gum_choose_or_default \
    "Confirm installer profile" \
    "$DETECTED_PROFILE" \
    "$DETECTED_PROFILE" laptop desktop vm)" || return 1

  SELECTED_PROFILE="$choice"
  log_ok "Selected profile: ${SELECTED_PROFILE} (${MONITOR_COUNT} monitor(s))"
}
