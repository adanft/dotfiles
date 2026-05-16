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
    playerctl
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
}
