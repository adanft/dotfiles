#!/usr/bin/env bash

interactive_terminal() {
  # stdout may be captured by command substitution when callers need the
  # selected value. Use stderr for interactivity because prompts render there.
  [[ -t 0 && -t 2 ]]
}

gum_confirm_or_prompt() {
  local message="$1"

  if ! interactive_terminal; then
    log_warn "No interactive terminal available; refusing confirmation for: $message"
    return 1
  fi

  local answer
  printf '%s [y/N]: ' "$message" >&2
  read -r answer
  [[ "$answer" =~ ^[Yy]$|^[Yy][Ee][Ss]$ ]]
}

gum_choose() {
  local prompt="$1"
  shift
  local choices=("$@")

  if ! interactive_terminal; then
    log_warn "No interactive terminal available; cannot select a profile."
    return 1
  fi

  printf '%s\n' "$prompt" >&2

  local index choice answer
  for index in "${!choices[@]}"; do
    printf '  %d) %s\n' "$((index + 1))" "${choices[$index]}" >&2
  done

  printf 'Choose profile: ' >&2
  read -r answer

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
