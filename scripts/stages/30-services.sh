#!/usr/bin/env bash

stage_services() {
  log_info "Enabling system services."

  if [[ "$DRY_RUN" == "1" ]]; then
    enable_system_service greetd.service
  elif ! gum_confirm_or_prompt "Enable greetd.service now?"; then
    log_warn "Skipping greetd.service enablement."
  else
    enable_system_service greetd.service
  fi

  if [[ "$SELECTED_PROFILE" == "laptop" || "$SELECTED_PROFILE" == "desktop" ]]; then
    enable_system_service power-profiles-daemon.service
  else
    log_info "Skipping power-profiles-daemon.service for profile: $SELECTED_PROFILE"
  fi

  if [[ "$SELECTED_PROFILE" == "laptop" || "$SELECTED_PROFILE" == "desktop" ]]; then
    enable_system_service bluetooth.service
  else
    log_info "Skipping Bluetooth packages/services for profile: $SELECTED_PROFILE"
  fi
}
