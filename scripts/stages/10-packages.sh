#!/usr/bin/env bash

stage_packages() {
  select_profile || die "Profile selection cancelled."

  log_info "Installing official Arch packages for Hyprland and basic dev tooling."

  local base_packages=(
    hyprland
    xdg-desktop-portal-hyprland
    waybar
    rofi
    thunar
    ghostty
    alacritty
    kitty
    zsh
    starship
    tmux
    neovim
    yazi
    fastfetch
    hyprpaper
    hypridle
    hyprlock
    hyprpicker
    swaync
    wireplumber
    polkit-gnome
    greetd
    greetd-tuigreet
    plymouth
    grim
    slurp
    imv
    wl-clipboard
    jq
    libnotify
    which
    xdg-user-dirs
    networkmanager
    git
    bat
    fzf
    lsd
    zoxide
    ttf-iosevkaterm-nerd
    ttf-nerd-fonts-symbols
  )

  install_pacman_packages "${base_packages[@]}"

  local profile_packages=()

  if [[ "$SELECTED_PROFILE" == "laptop" || "$SELECTED_PROFILE" == "desktop" ]]; then
    # Laptop/desktop Waybar profiles expose Bluetooth and open blueman-manager.
    profile_packages+=(blueman)
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
