#!/usr/bin/env bash

stage_packages() {
  log_info "Installing official Arch packages for Hyprland and basic dev tooling."

  local packages=(
    gum
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
    pipewire
    wireplumber
    playerctl
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

  if [[ "$SELECTED_PROFILE" == "laptop" || "$SELECTED_PROFILE" == "desktop" ]]; then
    # Laptop/desktop Waybar profiles expose Bluetooth and open blueman-manager.
    packages+=(bluez blueman)
  fi

  if [[ "$SELECTED_PROFILE" == "laptop" ]]; then
    packages+=(brightnessctl power-profiles-daemon)
  elif [[ "$SELECTED_PROFILE" == "desktop" ]]; then
    packages+=(power-profiles-daemon)
  fi

  install_pacman_packages "${packages[@]}"
}
