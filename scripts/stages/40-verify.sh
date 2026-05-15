#!/usr/bin/env bash

stage_verify() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "Dry-run mode: skipping live post-install verification."
    log_info "Would verify key commands and service state after a real install."
    return 0
  fi

  log_info "Verifying key commands. Warnings here do not fail the installer."

  local commands=(
    Hyprland
    waybar
    rofi
    ghostty
    alacritty
    kitty
    zsh
    starship
    tmux
    nvim
    yazi
    fastfetch
    hyprpaper
    hypridle
    hyprlock
    swaync
    grim
    slurp
    imv
    wl-copy
    jq
  )

  local cmd
  for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      log_ok "Found command: $cmd"
    else
      log_warn "Missing command after install: $cmd"
    fi
  done

  if system_service_enabled greetd.service; then
    log_ok "greetd.service is enabled."
  else
    log_warn "greetd.service is not enabled."
  fi

  warn_unmanaged_visual_assets
}

warn_unmanaged_visual_assets() {
  if ! command -v fc-match >/dev/null 2>&1; then
    log_warn "fontconfig/fc-match is unavailable; cannot verify UI font availability."
  elif [[ "$(fc-match -f '%{family}\n' "SF Pro Display")" != *"SF Pro Display"* ]]; then
    log_warn "Required font missing: SF Pro Display. Install it locally from: https://github.com/chris-short/apple-san-francisco-pro-fonts"
  fi

  if [[ ! -d "$HOME/.themes/Sweet-Ambar-Blue-Dark-v40" && ! -d "/usr/share/themes/Sweet-Ambar-Blue-Dark-v40" ]]; then
    log_warn "Sweet-Ambar-Blue-Dark-v40 GTK theme is referenced but not installed by this repo."
  fi

  if [[ ! -d "$HOME/.icons/Sweet-cursors" && ! -d "/usr/share/icons/Sweet-cursors" ]]; then
    log_warn "Sweet-cursors icon theme is referenced but not installed by this repo."
  fi
}
