#!/usr/bin/env bash

stage_user_configs() {
  log_info "Copying repo-owned user configs into local home."

  local links=(
    ".config/ghostty:$HOME/.config/ghostty"
    ".config/alacritty:$HOME/.config/alacritty"
    ".config/kitty:$HOME/.config/kitty"
    ".config/starship:$HOME/.config/starship"
    ".config/fastfetch:$HOME/.config/fastfetch"
    ".zshrc:$HOME/.zshrc"
    ".colors.sh:$HOME/.colors.sh"
    "Wallpapers:$HOME/Wallpapers"
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
    "scripts"
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
