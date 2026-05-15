#!/usr/bin/env bash

stage_user_configs() {
  log_info "Linking repo-owned user configs."

  local links=(
    ".config/hypr:$HOME/.config/hypr"
    ".config/waybar:$HOME/.config/waybar"
    ".config/rofi:$HOME/.config/rofi"
    ".config/swaync:$HOME/.config/swaync"
    ".config/ghostty:$HOME/.config/ghostty"
    ".config/alacritty:$HOME/.config/alacritty"
    ".config/kitty:$HOME/.config/kitty"
    ".config/starship:$HOME/.config/starship"
    ".config/fastfetch:$HOME/.config/fastfetch"
    ".tmux:$HOME/.tmux"
    ".tmux.conf:$HOME/.tmux.conf"
    ".zshrc:$HOME/.zshrc"
    "Wallpapers:$HOME/Wallpapers"
    ".face:$HOME/.face"
  )

  local pair source_rel target
  for pair in "${links[@]}"; do
    source_rel="${pair%%:*}"
    target="${pair#*:}"
    link_config "$REPO_ROOT/$source_rel" "$target"

    if [[ "$source_rel" == ".config/hypr" ]]; then
      apply_hypridle_profile
    fi

    if [[ "$source_rel" == ".config/waybar" ]]; then
      apply_waybar_profile
    fi

    if [[ "$source_rel" == ".config/rofi" ]]; then
      apply_rofi_power_menu_profile
    fi
  done

  set_default_shell_zsh
}

apply_rofi_power_menu_profile() {
  local default_script="$REPO_ROOT/.config/rofi/scripts/power-menu.sh"
  local vm_script="$REPO_ROOT/.config/rofi/scripts/power-menu-vm.sh"
  local active_script="$REPO_ROOT/.config/rofi/scripts/power-menu-active.sh"
  local home_active_script="$HOME/.config/rofi/scripts/power-menu-active.sh"
  local active_link="power-menu.sh"

  if [[ "$SELECTED_PROFILE" == "vm" ]]; then
    active_link="power-menu-vm.sh"
    [[ -f "$vm_script" ]] || die "Missing VM Rofi power menu script: $vm_script"
  else
    [[ -f "$default_script" ]] || die "Missing default Rofi power menu script: $default_script"
  fi

  if [[ -L "$active_script" ]]; then
    local current current_abs selected_abs selected_script
    selected_script="$default_script"
    [[ "$SELECTED_PROFILE" == "vm" ]] && selected_script="$vm_script"

    current="$(readlink "$active_script")"
    current_abs="$(cd -- "$(dirname -- "$active_script")" && readlink -f -- "$current" 2>/dev/null || true)"
    selected_abs="$(readlink -f -- "$selected_script")"

    if [[ "$current" == "$active_link" || "$current_abs" == "$selected_abs" ]]; then
      log_ok "Rofi power menu profile already active: $SELECTED_PROFILE"
      return 0
    fi
  fi

  log_info "Applying Rofi power menu profile: $SELECTED_PROFILE"
  run_cmd mkdir -p "$(dirname "$active_script")"
  backup_existing_target "$active_script"
  run_cmd ln -s "$active_link" "$active_script"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "dry-run: would link $active_script -> $active_link"
    log_info "dry-run: active power menu would resolve via $home_active_script"
  else
    log_ok "Linked Rofi power menu profile: $active_script -> $active_link"
    log_ok "Active Rofi power menu resolves via $home_active_script"
  fi
}

apply_hypridle_profile() {
  local profile_config="$REPO_ROOT/.config/hypr/profiles/$SELECTED_PROFILE/hypridle.conf"
  local active_config="$REPO_ROOT/.config/hypr/hypridle.conf"
  local home_active_config="$HOME/.config/hypr/hypridle.conf"
  local active_link="profiles/$SELECTED_PROFILE/hypridle.conf"

  [[ -f "$profile_config" ]] || \
    die "Missing hypridle config for selected profile: $SELECTED_PROFILE"

  if [[ -L "$active_config" ]]; then
    local current current_abs selected_abs
    current="$(readlink "$active_config")"
    current_abs="$(cd -- "$(dirname -- "$active_config")" && readlink -f -- "$current" 2>/dev/null || true)"
    selected_abs="$(readlink -f -- "$profile_config")"

    if [[ "$current" == "$active_link" || "$current_abs" == "$selected_abs" ]]; then
      log_ok "Hypridle profile already active: $SELECTED_PROFILE"
      return 0
    fi
  fi

  log_info "Applying hypridle profile: $SELECTED_PROFILE"
  run_cmd mkdir -p "$(dirname "$active_config")"
  backup_existing_target "$active_config"
  run_cmd ln -s "$active_link" "$active_config"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "dry-run: would link $active_config -> $active_link"
    log_info "dry-run: active config would resolve via $home_active_config"
  else
    log_ok "Linked hypridle profile: $active_config -> $active_link"
    log_ok "Active hypridle config resolves via $home_active_config"
  fi
}

apply_waybar_profile() {
  local profile_config="$REPO_ROOT/.config/waybar/profiles/$SELECTED_PROFILE/config.jsonc"
  local active_config="$REPO_ROOT/.config/waybar/config.jsonc"
  local home_active_config="$HOME/.config/waybar/config.jsonc"
  local active_link="profiles/$SELECTED_PROFILE/config.jsonc"

  [[ -f "$profile_config" ]] || \
    die "Missing Waybar config for selected profile: $SELECTED_PROFILE"

  if [[ -L "$active_config" ]]; then
    local current current_abs selected_abs
    current="$(readlink "$active_config")"
    current_abs="$(cd -- "$(dirname -- "$active_config")" && readlink -f -- "$current" 2>/dev/null || true)"
    selected_abs="$(readlink -f -- "$profile_config")"

    if [[ "$current" == "$active_link" || "$current_abs" == "$selected_abs" ]]; then
      log_ok "Waybar profile already active: $SELECTED_PROFILE"
      return 0
    fi
  fi

  log_info "Applying Waybar profile: $SELECTED_PROFILE"
  run_cmd mkdir -p "$(dirname "$active_config")"
  backup_existing_target "$active_config"
  run_cmd ln -s "$active_link" "$active_config"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "dry-run: would link $active_config -> $active_link"
    log_info "dry-run: active config would resolve via $home_active_config"
  else
    log_ok "Linked Waybar profile: $active_config -> $active_link"
    log_ok "Active Waybar config resolves via $home_active_config"
  fi
}

set_default_shell_zsh() {
  local zsh_path current_shell
  zsh_path="$(command -v zsh || true)"
  [[ -n "$zsh_path" ]] || zsh_path="/usr/bin/zsh"

  if ! grep -Fxq "$zsh_path" /etc/shells; then
    log_warn "zsh path is not listed in /etc/shells: $zsh_path"
    log_warn "Skipping chsh. Add it to /etc/shells, then run: chsh -s $zsh_path $USER"
    return 0
  fi

  current_shell="$(getent passwd "$USER" | cut -d: -f7)"
  if [[ "$current_shell" == "$zsh_path" ]]; then
    log_ok "Default shell already set to zsh."
    return 0
  fi

  log_warn "Changing default shell for $USER to $zsh_path."
  if ! run_cmd chsh -s "$zsh_path" "$USER"; then
    log_warn "Could not change the default shell automatically. Run manually: chsh -s $zsh_path $USER"
  fi
}
