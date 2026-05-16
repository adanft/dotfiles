#!/usr/bin/env bash

pacman_installed() {
  pacman -Qq "$1" >/dev/null 2>&1
}

install_pacman_packages() {
  local packages=("$@")
  local missing=()
  local pkg

  for pkg in "${packages[@]}"; do
    if pacman_installed "$pkg"; then
      log_ok "Package already installed: $pkg"
    else
      missing+=("$pkg")
    fi
  done

  if (( ${#missing[@]} == 0 )); then
    log_ok "All requested packages are already installed."
    return 0
  fi

  run_root pacman -S --needed --noconfirm "${missing[@]}"
}
