#!/usr/bin/env bash

confirm_and_enable_service() {
  local service="$1"

  if [[ "$DRY_RUN" == "1" ]]; then
    enable_system_service "$service"
    return 0
  fi

  if ! gum_confirm_or_prompt "Enable $service now?"; then
    log_warn "Skipping $service enablement."
    return 0
  fi

  enable_system_service "$service"
}

stage_services() {
  log_info "Enabling system services."

  confirm_and_enable_service NetworkManager.service
  confirm_and_enable_service greetd.service

  if [[ "$SELECTED_PROFILE" == "laptop" || "$SELECTED_PROFILE" == "desktop" ]]; then
    confirm_and_enable_service power-profiles-daemon.service
  else
    log_info "Skipping power-profiles-daemon.service for profile: $SELECTED_PROFILE"
  fi

  if [[ "$SELECTED_PROFILE" == "laptop" || "$SELECTED_PROFILE" == "desktop" ]]; then
    confirm_and_enable_service bluetooth.service
  else
    log_info "Skipping Bluetooth packages/services for profile: $SELECTED_PROFILE"
  fi
}
