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
  local choices=("$@")

  if have_gum && interactive_terminal; then
    gum choose --header "$prompt" "${choices[@]}"
    return $?
  fi

  if ! interactive_terminal; then
    log_warn "No interactive terminal available; using detected default: $default"
    printf '%s\n' "$default"
    return 0
  fi

  log_warn "gum prompt is unavailable; using basic text prompt."
  printf '%s\n' "$prompt" >&2

  local index choice answer
  for index in "${!choices[@]}"; do
    printf '  %d) %s\n' "$((index + 1))" "${choices[$index]}" >&2
  done

  printf 'Choose profile [%s]: ' "$default" >&2
  read -r answer

  [[ -z "$answer" ]] && {
    printf '%s\n' "$default"
    return 0
  }

  if [[ "$answer" =~ ^[0-9]+$ ]] && (( answer >= 1 && answer <= ${#choices[@]} )); then
    printf '%s\n' "${choices[$((answer - 1))]}"
    return 0
  fi

  for choice in "${choices[@]}"; do
    if [[ "$answer" == "$choice" ]]; then
      printf '%s\n' "$choice"
      return 0
    fi
  done

  log_warn "Invalid choice: $answer"
  return 1
}
