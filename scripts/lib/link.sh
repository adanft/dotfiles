#!/usr/bin/env bash

link_config() {
  local source="$1"
  local target="$2"

  [[ -e "$source" || -L "$source" ]] || {
    log_warn "Skipping missing source: $source"
    return 0
  }

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      log_ok "Link already correct: $target"
      return 0
    fi
  fi

  run_cmd mkdir -p "$(dirname "$target")"
  backup_existing_target "$target"
  run_cmd ln -s "$source" "$target"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "dry-run: would link $target -> $source"
  else
    log_ok "Linked: $target -> $source"
  fi
}
