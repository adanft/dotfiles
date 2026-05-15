#!/usr/bin/env bash

stage_preflight() {
  log_info "Running preflight checks."

  if [[ "${EUID}" -eq 0 ]]; then
    die "Do not run this installer as root. Run it as your user; privileged steps use sudo when needed."
  fi

  [[ -r /etc/arch-release ]] || die "This installer supports Arch Linux only."
  command -v pacman >/dev/null 2>&1 || die "pacman is required."

  detect_profile
}
