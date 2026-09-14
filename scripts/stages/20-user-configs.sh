#!/usr/bin/env bash

stage_user_configs() {
  log_info "Copying repo-owned user configs into local home."

  local links=(
    ".config/ghostty:$HOME/.config/ghostty"
    ".config/alacritty:$HOME/.config/alacritty"
    ".config/kitty:$HOME/.config/kitty"
    ".config/starship:$HOME/.config/starship"
    ".config/fastfetch:$HOME/.config/fastfetch"
    ".tmux:$HOME/.tmux"
    ".tmux.conf:$HOME/.tmux.conf"
    ".zshrc:$HOME/.zshrc"
    ".colors.sh:$HOME/.colors.sh"
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

  set_default_shell_zsh
}

ensure_real_dir() {
  local target="$1"

  if [[ -d "$target" ]]; then
    log_ok "Directory already exists: $target"
    return 0
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    die "Cannot create directory because a non-directory already exists: $target"
  fi

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
    "hyprland.lua" \
    "hyprlock.conf" \
    "hyprpaper.conf" \
    "scripts" \
    "theme.conf"

  apply_hypridle_profile
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

apply_hypridle_profile() {
  local profile_config="$REPO_ROOT/.config/hypr/profiles/$SELECTED_PROFILE/hypridle.conf"
  local home_active_config="$HOME/.config/hypr/hypridle.conf"

  [[ -f "$profile_config" ]] || \
    die "Missing hypridle config for selected profile: $SELECTED_PROFILE"

  copy_active_profile_file "Hypridle" "$profile_config" "$home_active_config"
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
