#!/usr/bin/env bash

normalize_mode() {
  local mode="$1"
  printf '%s\n' "${mode#0}"
}

file_mode() {
  stat -c '%a' "$1" 2>/dev/null || true
}

system_file_backup_path() {
  local target="$1"
  local timestamp
  timestamp="$(date +%Y%m%d-%H%M%S)"
  printf '%s.backup.%s\n' "$target" "$timestamp"
}

install_system_file() {
  local source="$1"
  local target="$2"
  local mode="$3"

  [[ -f "$source" ]] || die "Missing source file for system install: $source"

  local desired_mode current_mode
  desired_mode="$(normalize_mode "$mode")"

  if [[ -e "$target" || -L "$target" ]]; then
    current_mode="$(file_mode "$target")"

    if cmp -s "$source" "$target"; then
      if [[ "$current_mode" == "$desired_mode" ]]; then
        log_ok "System file already current: $target"
        return 0
      fi

      log_info "System file content already current; fixing mode: $target ($current_mode -> $desired_mode)"
      run_root chmod "$mode" "$target"
      return 0
    fi

    local backup
    backup="$(system_file_backup_path "$target")"
    log_warn "Backing up changed system file: $target -> $backup"
    run_root mv "$target" "$backup"
  fi

  log_info "Installing system file: $source -> $target (mode $mode)"
  run_root install "-Dm$mode" "$source" "$target"
}
