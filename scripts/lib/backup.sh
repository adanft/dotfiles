#!/usr/bin/env bash

backup_path() {
  local target="$1"
  local timestamp
  local relative
  timestamp="$(date +%Y%m%d-%H%M%S)"

  relative="${target#$HOME/}"
  relative="${relative#/}"

  printf '%s/.local/state/dotfiles-installer/backups/%s/%s\n' \
    "$HOME" "$timestamp" "$relative"
}

backup_existing_target() {
  local target="$1"

  [[ -e "$target" || -L "$target" ]] || return 0

  if [[ -d "$target" && ! -L "$target" ]]; then
    log_warn "Refusing to backup directory automatically: $target"
    return 1
  fi

  local backup
  backup="$(backup_path "$target")"
  log_warn "Backing up existing target: $target -> $backup"
  run_cmd mkdir -p "$(dirname "$backup")"
  run_cmd mv "$target" "$backup"
}
