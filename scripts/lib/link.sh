#!/usr/bin/env bash

config_target_current() {
  local source="$1"
  local target="$2"

  [[ -e "$target" && ! -L "$target" ]] || return 1

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

  if [[ -d "$source" && ! -L "$source" ]]; then
    copy_config_dir "$source" "$target"
    return 0
  fi

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

copy_config_dir() {
  local source_dir="$1"
  local target_dir="$2"
  local child child_name

  if [[ -e "$target_dir" && ! -d "$target_dir" ]]; then
    die "Cannot create directory because a non-directory already exists: $target_dir"
  fi

  run_cmd mkdir -p "$target_dir"

  shopt -s dotglob nullglob
  for child in "$source_dir"/*; do
    child_name="$(basename "$child")"
    copy_config "$child" "$target_dir/$child_name"
  done
  shopt -u dotglob nullglob
}
