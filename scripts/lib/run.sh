#!/usr/bin/env bash

# Route every mutation through this file so --dry-run stays honest.

: "${DRY_RUN:=0}"

quote_cmd() {
  local quoted=()
  local arg
  for arg in "$@"; do
    printf -v arg '%q' "$arg"
    quoted+=("$arg")
  done
  printf '%s' "${quoted[*]}"
}

run_cmd() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "dry-run: $(quote_cmd "$@")"
    return 0
  fi

  log_info "run: $(quote_cmd "$@")"
  "$@"
}

run_root() {
  if [[ "${EUID}" -eq 0 ]]; then
    run_cmd "$@"
  elif command -v sudo >/dev/null 2>&1; then
    run_cmd sudo "$@"
  else
    die "This step needs root privileges, and sudo is not installed."
  fi
}
