#!/usr/bin/env bash

backup_path() {
  local target="$1"
  local timestamp
  timestamp="$(date +%Y%m%d-%H%M%S)"
  printf '%s.backup.%s\n' "$target" "$timestamp"
}

backup_existing_target() {
  local target="$1"

  [[ -e "$target" || -L "$target" ]] || return 0

  local backup
  backup="$(backup_path "$target")"
  log_warn "Backing up existing target: $target -> $backup"
  run_cmd mv "$target" "$backup"
}
