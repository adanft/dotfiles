#!/usr/bin/env bash

backup_path() {
  local target="$1"
  local dir base name ext timestamp backup candidate counter

  timestamp="$(date +%Y%m%d-%H%M%S-%N)"
  dir="$(dirname "$target")"
  base="$(basename "$target")"

  if [[ "$base" == *.* && "$base" != .* ]]; then
    name="${base%.*}"
    ext=".${base##*.}"
  else
    name="$base"
    ext=""
  fi

  backup="$dir/$name.backup.$timestamp$ext"
  candidate="$backup"
  counter=1

  while [[ -e "$candidate" || -L "$candidate" ]]; do
    candidate="$dir/$name.backup.$timestamp.$counter$ext"
    counter=$((counter + 1))
  done

  printf '%s\n' "$candidate"
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
