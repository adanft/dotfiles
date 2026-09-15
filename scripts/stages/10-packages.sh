#!/usr/bin/env bash

stage_packages() {
  select_profile || die "Profile selection cancelled."

  log_info "Installing official Arch packages for Hyprland and basic dev tooling."

  local base_packages=(
    hyprland
    xdg-desktop-portal-hyprland
    thunar
    ghostty
    alacritty
    kitty
    zsh
    starship
    neovim
    yazi
    fastfetch
    hyprpicker
    wireplumber
    playerctl
    greetd
    greetd-tuigreet
    plymouth
    grim
    slurp
    imv
    wl-clipboard
    jq
    kbd
    libnotify
    which
    xdg-user-dirs
    networkmanager
    git
    bat
    fzf
    eza
    zoxide
    ttf-iosevkaterm-nerd
    ttf-nerd-fonts-symbols
  )

  install_pacman_packages "${base_packages[@]}"

  local profile_packages=()

  if [[ "$SELECTED_PROFILE" == "laptop" || "$SELECTED_PROFILE" == "desktop" ]]; then
    # Keep Bluetooth functional without installing a graphical manager.
    profile_packages+=(bluez bluez-utils)
  fi

  if [[ "$SELECTED_PROFILE" == "laptop" ]]; then
    profile_packages+=(brightnessctl power-profiles-daemon)
  elif [[ "$SELECTED_PROFILE" == "desktop" ]]; then
    profile_packages+=(power-profiles-daemon)
  fi

  if (( ${#profile_packages[@]} > 0 )); then
    install_pacman_packages "${profile_packages[@]}"
  else
    log_info "No extra packages required for profile: $SELECTED_PROFILE"
  fi
}
