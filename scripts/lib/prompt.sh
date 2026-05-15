#!/usr/bin/env bash

have_gum() {
  command -v gum >/dev/null 2>&1
}

interactive_terminal() {
  [[ -t 0 && -t 1 ]]
}

gum_confirm_or_prompt() {
  local message="$1"

  if have_gum && interactive_terminal; then
    gum confirm "$message"
    return $?
  fi

  if ! interactive_terminal; then
    log_warn "No interactive terminal available; refusing confirmation for: $message"
    return 1
  fi

  local answer
  printf '%s [y/N]: ' "$message" >&2
  read -r answer
  [[ "$answer" =~ ^[Yy]$|^[Yy][Ee][Ss]$ ]]
}

gum_choose_or_default() {
  local prompt="$1"
  local default="$2"
  shift 2

  if have_gum && interactive_terminal; then
    gum choose --header "$prompt" "$@"
    return $?
  fi

  log_warn "Interactive gum prompt is unavailable; using detected default: $default"
  printf '%s\n' "$default"
}
