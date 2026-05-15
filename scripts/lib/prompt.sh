#!/usr/bin/env bash

have_gum() {
  command -v gum >/dev/null 2>&1
}

interactive_terminal() {
  # stdout may be captured by command substitution when callers need the
  # selected value. Use stderr for interactivity because prompts render there.
  [[ -t 0 && -t 2 ]]
}

gum_confirm_or_prompt() {
  local message="$1"

  if have_gum && interactive_terminal; then
    gum confirm "$message"
    return $?
  fi

  log_warn "gum is required for confirmation prompts: $message"
  return 1
}

gum_choose_or_default() {
  local prompt="$1"
  local default="$2"
  shift 2
  local choices=("$@")

  if have_gum && interactive_terminal; then
    gum choose --header "$prompt" "${choices[@]}"
    return $?
  fi

  log_warn "gum is required for selection prompts: $prompt"
  return 1
}
