#!/usr/bin/env bash

system_service_enabled() {
  systemctl is-enabled --quiet "$1" 2>/dev/null
}

enable_system_service() {
  local service="$1"

  if system_service_enabled "$service"; then
    log_ok "Service already enabled: $service"
    return 0
  fi

  run_root systemctl enable "$service"
}
