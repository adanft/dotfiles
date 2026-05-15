#!/usr/bin/env bash

config_target_current() {
  local source="$1"
  local target="$2"

  [[ -e "$target" && ! -L "$target" ]] || return 1

  if [[ -d "$source" && -d "$target" ]]; then
    diff -qr "$source" "$target" >/dev/null 2>&1
    return $?
  fi

  if [[ -f "$source" && -f "$target" ]]; then
    cmp -s "$source" "$target"
    return $?
  fi

  return 1
}

copy_config() {
  local source="$1"
  local target="$2"

  [[ -e "$source" || -L "$source" ]] || {
    log_warn "Skipping missing source: $source"
    return 0
  }

  if config_target_current "$source" "$target"; then
    log_ok "Config already current: $target"
    return 0
  fi

  run_cmd mkdir -p "$(dirname "$target")"
  backup_existing_target "$target"
  run_cmd cp -a "$source" "$target"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "dry-run: would copy $source -> $target"
  else
    log_ok "Copied: $source -> $target"
  fi
}
