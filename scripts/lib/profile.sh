#!/usr/bin/env bash

select_profile() {
  local choice
  choice="$(gum_choose \
    "Select installer profile" \
    laptop desktop vm)" || return 1

  SELECTED_PROFILE="$choice"
  log_ok "Selected profile: ${SELECTED_PROFILE}"
}
