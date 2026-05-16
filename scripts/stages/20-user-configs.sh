#!/usr/bin/env bash

stage_user_configs() {
  log_info "Copying repo-owned user configs into local home."

  local links=(
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
    copy_config "$REPO_ROOT/$source_rel" "$target"
  done

  copy_hypr_config
  copy_waybar_config
  copy_rofi_config

  set_default_shell_zsh
}

ensure_real_dir() {
  local target="$1"

  if [[ -d "$target" && ! -L "$target" ]]; then
    log_ok "Directory already exists: $target"
    return 0
  fi

  run_cmd mkdir -p "$(dirname "$target")"
  backup_existing_target "$target"
  run_cmd mkdir -p "$target"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "dry-run: would ensure real directory $target"
  else
    log_ok "Created directory: $target"
  fi
}

copy_config_children() {
  local source_dir="$1"
  local target_dir="$2"
  shift 2

  ensure_real_dir "$target_dir"

  local child
  for child in "$@"; do
    copy_config "$source_dir/$child" "$target_dir/$child"
  done
}

copy_hypr_config() {
  copy_config_children "$REPO_ROOT/.config/hypr" "$HOME/.config/hypr" \
    ".luarc.json" \
    "active" \
    "hyprland.lua" \
    "hyprlock.conf" \
    "hyprpaper.conf" \
    "scripts" \
    "theme.conf"

  apply_hypridle_profile
}

copy_waybar_config() {
  copy_config_children "$REPO_ROOT/.config/waybar" "$HOME/.config/waybar" \
    "style.css" \
    "theme.css"

  apply_waybar_profile
}

copy_rofi_config() {
  ensure_real_dir "$HOME/.config/rofi"
  copy_config "$REPO_ROOT/.config/rofi/shared" "$HOME/.config/rofi/shared"
  copy_config "$REPO_ROOT/.config/rofi/themes" "$HOME/.config/rofi/themes"

  copy_config_children "$REPO_ROOT/.config/rofi/scripts" "$HOME/.config/rofi/scripts" \
    "power-menu.sh" \
    "power-menu-vm.sh" \
    "screenshot.sh"

  apply_rofi_power_menu_profile
}

apply_rofi_power_menu_theme() {
  local default_theme="$REPO_ROOT/.config/rofi/themes/power-menu.rasi"
  local vm_theme="$REPO_ROOT/.config/rofi/themes/power-menu-vm.rasi"
  local home_theme="$HOME/.config/rofi/themes/power-menu.rasi"
  local selected_theme="$default_theme"

  if [[ "$SELECTED_PROFILE" == "vm" ]]; then
    selected_theme="$vm_theme"
    [[ -f "$vm_theme" ]] || die "Missing VM Rofi power menu theme: $vm_theme"
  else
    [[ -f "$default_theme" ]] || die "Missing default Rofi power menu theme: $default_theme"
  fi

  copy_active_profile_file "Rofi power menu theme" "$selected_theme" "$home_theme"
}

copy_active_profile_file() {
  local label="$1"
  local source="$2"
  local target="$3"

  if config_target_current "$source" "$target"; then
    log_ok "$label profile already active locally: $SELECTED_PROFILE"
    return 0
  fi

  log_info "Applying $label profile: $SELECTED_PROFILE"
  ensure_real_dir "$(dirname "$target")"
  backup_existing_target "$target"
  run_cmd cp -a "$source" "$target"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "dry-run: would copy $source -> $target"
  else
    log_ok "Copied $label profile locally: $source -> $target"
  fi
}

apply_rofi_power_menu_profile() {
  local default_script="$REPO_ROOT/.config/rofi/scripts/power-menu.sh"
  local vm_script="$REPO_ROOT/.config/rofi/scripts/power-menu-vm.sh"
  local home_active_script="$HOME/.config/rofi/scripts/power-menu-active.sh"
  local selected_script="$default_script"

  if [[ "$SELECTED_PROFILE" == "vm" ]]; then
    selected_script="$vm_script"
    [[ -f "$vm_script" ]] || die "Missing VM Rofi power menu script: $vm_script"
  else
    [[ -f "$default_script" ]] || die "Missing default Rofi power menu script: $default_script"
  fi

  copy_active_profile_file "Rofi power menu" "$selected_script" "$home_active_script"
  apply_rofi_power_menu_theme
}

apply_hypridle_profile() {
  local profile_config="$REPO_ROOT/.config/hypr/profiles/$SELECTED_PROFILE/hypridle.conf"
  local home_active_config="$HOME/.config/hypr/hypridle.conf"

  [[ -f "$profile_config" ]] || \
    die "Missing hypridle config for selected profile: $SELECTED_PROFILE"

  copy_active_profile_file "Hypridle" "$profile_config" "$home_active_config"
}

apply_waybar_profile() {
  local profile_config="$REPO_ROOT/.config/waybar/profiles/$SELECTED_PROFILE/config.jsonc"
  local home_active_config="$HOME/.config/waybar/config.jsonc"

  [[ -f "$profile_config" ]] || \
    die "Missing Waybar config for selected profile: $SELECTED_PROFILE"

  copy_active_profile_file "Waybar" "$profile_config" "$home_active_config"
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
