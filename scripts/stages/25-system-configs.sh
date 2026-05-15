#!/usr/bin/env bash

install_plymouth_theme() {
  log_info "Installing Plymouth theme files."

  install_system_file "$REPO_ROOT/plymouth/custom.plymouth" /usr/share/plymouth/themes/custom/custom.plymouth 0644
  install_system_file "$REPO_ROOT/plymouth/custom.script" /usr/share/plymouth/themes/custom/custom.script 0644
  install_system_file "$REPO_ROOT/plymouth/logo.png" /usr/share/plymouth/themes/custom/logo.png 0644
  install_system_file "$REPO_ROOT/plymouth/spinner.png" /usr/share/plymouth/themes/custom/spinner.png 0644
}

current_plymouth_theme() {
  local output theme
  output="$(plymouth-set-default-theme 2>/dev/null || true)"
  read -r theme _ <<< "$output"
  printf '%s\n' "$theme"
}

set_default_plymouth_theme() {
  local theme="custom"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "Would ensure default Plymouth theme is: $theme"
    run_root plymouth-set-default-theme "$theme"
    return 0
  fi

  if ! command -v plymouth-set-default-theme >/dev/null 2>&1; then
    log_warn "plymouth-set-default-theme is unavailable; install the plymouth package before setting the default theme."
    return 0
  fi

  local current_theme
  current_theme="$(current_plymouth_theme)"
  if [[ "$current_theme" == "$theme" ]]; then
    log_ok "Default Plymouth theme already current: $theme"
    return 0
  fi

  log_info "Setting default Plymouth theme: $theme"
  run_root plymouth-set-default-theme "$theme"
}

warn_if_mkinitcpio_missing_plymouth_hook() {
  local config="/etc/mkinitcpio.conf"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "Would inspect $config for a plymouth HOOKS entry."
    return 0
  fi

  if [[ ! -r "$config" ]]; then
    log_warn "Cannot inspect $config; ensure the plymouth hook is present before expecting boot splash output."
    return 0
  fi

  local hooks_line hooks
  hooks_line="$(while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*HOOKS= ]] || continue
    printf '%s\n' "$line"
    break
  done < "$config")"
  hooks="${hooks_line#*=}"
  hooks="${hooks//[\(\)\"\']/ }"

  if [[ ! " $hooks " =~ [[:space:]]plymouth[[:space:]] ]]; then
    log_warn "$config HOOKS does not appear to include plymouth; theme files are installed, but boot splash may not appear."
  fi
}

regenerate_initramfs_if_confirmed() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log_info "Would ask before regenerating initramfs for Plymouth changes."
    run_root mkinitcpio -P
    return 0
  fi

  if ! command -v mkinitcpio >/dev/null 2>&1; then
    log_warn "mkinitcpio is unavailable; skipping initramfs regeneration."
    return 0
  fi

  if ! gum_confirm_or_prompt "Regenerate initramfs now with mkinitcpio -P for Plymouth changes?"; then
    log_warn "Skipping initramfs regeneration; run 'sudo mkinitcpio -P' later if Plymouth should apply at boot."
    return 0
  fi

  run_root mkinitcpio -P
}

stage_system_configs() {
  log_info "Installing system configuration files."

  install_system_file "$REPO_ROOT/greetd/config.toml" /etc/greetd/config.toml 0644
  install_system_file "$REPO_ROOT/greetd/start" /etc/greetd/start 0755

  install_plymouth_theme
  set_default_plymouth_theme
  warn_if_mkinitcpio_missing_plymouth_hook
  regenerate_initramfs_if_confirmed
}
