#!/usr/bin/env bash

valid_profile() {
  case "$1" in
    laptop|desktop|vm) return 0 ;;
    *) return 1 ;;
  esac
}

select_profile() {
  if [[ -n "$SELECTED_PROFILE" ]]; then
    valid_profile "$SELECTED_PROFILE" || die "Invalid profile: $SELECTED_PROFILE. Use one of: laptop, desktop, vm"
    log_ok "Selected profile: ${SELECTED_PROFILE}"
    return 0
  fi

  local choice
  choice="$(gum_choose \
    "Select installer profile" \
    laptop desktop vm)" || return 1

  SELECTED_PROFILE="$choice"
  log_ok "Selected profile: ${SELECTED_PROFILE}"
}
