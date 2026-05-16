# Personal Dotfiles

Personal Linux desktop dotfiles focused on Hyprland, Waybar, Zsh, Tmux and terminal tooling.

## Install

This repository includes an Arch Linux installer:

```sh
./install.sh
```

Preview the actions first with:

```sh
./install.sh --dry-run
```

The installer copies repo-owned files into `$HOME` and system config locations. It does **not** symlink configs to this repository, so the installed machine keeps working if the repo is deleted later.

### Profiles

During installation, choose one profile:

| Profile | Intended machine | Includes |
| ------- | ---------------- | -------- |
| `laptop` | Laptop Hyprland setup | Wi-Fi, LAN, Bluetooth, audio, microphone, battery, backlight, power profiles, suspend |
| `desktop` | Desktop Hyprland setup | Wi-Fi, LAN, Bluetooth, audio, microphone, tray, notifications, power profiles, suspend |
| `vm` | Virtual machine setup | Minimal Waybar, LAN only, no Bluetooth, no battery/backlight, no power profiles, no suspend |

Profile-specific files are copied into the normal runtime paths. For example, the VM power menu source has no suspend option, but it still installs as:

```sh
~/.config/rofi/scripts/power-menu.sh
```

### Safety model

- Existing directories are reused or created with `mkdir -p`.
- If a directory path is blocked by a file or symlink, the installer fails instead of replacing it.
- If a destination file already matches the repo file, nothing happens.
- If a destination file differs, the existing file is backed up next to itself before copying the repo version.
- The installer does not delete unknown existing files or directories.

Backup example:

```text
~/.config/rofi/scripts/power-menu.sh
~/.config/rofi/scripts/power-menu.backup.20260515-234249.sh
```

## Preview
![Preview result](https://github.com/adanft/dotfiles/blob/main/waybar.png)
![Preview result](https://github.com/adanft/dotfiles/blob/main/preview.png)

## Requirements
- Arch Linux

### Fonts
- SF Pro Display
- Symbols Nerd Font

SF Pro Display is not vendored in this repository. Install it separately from [apple-san-francisco-pro-fonts](https://github.com/chris-short/apple-san-francisco-pro-fonts).

### Others
- powerprofilesctl
- nmtui
- wpctl
- pactl
- alacritty

## Tmux plugins

The installer installs tmux and copies the tracked tmux configuration. After the install, set up TPM on the target machine and install the plugins:

1. Install TPM if it is not already present:

  ```sh
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ```

2. Open tmux and install the configured plugins with `prefix + I`.

Only the tmux configuration and helper scripts are tracked here. Do not copy plugin directories into the repository; TPM installs them on each machine.

### Tmux configuration
- Prefix: `Ctrl-a`
- Mouse support enabled
- Status bar at the top
- Vi keys in copy mode
- Windows and panes start at index `1`
- Windows are renumbered automatically
- History limit: `10000`
- Reload config: `prefix + r`
- Split panes in the current directory:
  - `prefix + v` for horizontal split
  - `prefix + d` for vertical split
- Destructive actions ask for confirmation before killing panes, windows, or sessions
- Sessions are preserved when the client terminal detaches or closes

### Configured tmux plugins
- `tmux-plugins/tpm`
- `tmux-plugins/tmux-resurrect`
- `tmux-plugins/tmux-continuum`
- `tmux-plugins/tmux-yank`
- `christoomey/vim-tmux-navigator`
- `alexwforsythe/tmux-which-key`

The plugin repositories are not part of these dotfiles. TPM/plugin installation is done on the target machine.

## Zsh

The installer installs Zsh tooling, copies the tracked shell config, and attempts to set Zsh as the default shell when possible.

The first Zsh startup needs internet access because `.zshrc` bootstraps Zinit automatically and downloads the configured plugins and Starship prompt.

## Neovim

The installer only installs the `neovim` binary. It does not copy or manage a Neovim config from this repository.

## TTY default colors via GRUB kernel parameters

This example uses GRUB kernel parameters. Other bootloaders like systemd-boot or Limine require setting the equivalent kernel command line in their own configuration.

- `GRUB_CMDLINE_LINUX="vt.default_red=24,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=24,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=37,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"`

## Multiple monitors configuration hyprland
```
monitor=DP-3,1920x1080@60,0x0,1
monitor=HDMI-A-1,2560x1440@120,1920x0,1
monitor=DP-1,2560x1440@70,4480x0,1,transform,3
```
