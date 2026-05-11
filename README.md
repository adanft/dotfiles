# Personal Dotfiles

Personal Linux desktop dotfiles focused on Hyprland, Waybar, Zsh, Tmux and terminal tooling.

## Preview
![Preview result](https://github.com/adanft/dotfiles/blob/main/waybar.png)
![Preview result](https://github.com/adanft/dotfiles/blob/main/preview.png)

## Requirements
### Fonts
- SF Pro Display
- Symbols Nerd Font
### Others
- powerprofilesctl
- nmtui
- wpctl
- pactl
- alacritty

## Tmux setup
- Install `tmux`, `git`, and `wl-clipboard`
- Copy `.tmux.conf` to `$HOME/.tmux.conf`
- Copy `.tmux/` to `$HOME/.tmux/`
- Install TPM:
  ```sh
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ```
- Open tmux and install the configured plugins with `prefix + I`

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

### Tmux plugins
- `tmux-plugins/tpm`
- `tmux-plugins/tmux-resurrect`
- `tmux-plugins/tmux-continuum`
- `tmux-plugins/tmux-yank`
- `christoomey/vim-tmux-navigator`
- `alexwforsythe/tmux-which-key`

The plugin repositories are not part of these dotfiles. TPM/plugin installation is done on the target machine.

## Zsh setup
- Install `zsh`, `git`, `tmux`, `fzf`, `zoxide`, `lsd`, `bat`, `fastfetch`, and `neovim`
- Change your default shell with `chsh -s $(which zsh)` and relog if needed
- Copy `.zshrc` and `.colors.sh` to `$HOME/`
- Make sure the `en_US.UTF-8` locale is generated on your system
- Use a Nerd Font in your terminal
- Copy `.config/starship/starship.toml` to `$HOME/.config/starship/starship.toml`

The first Zsh startup also needs internet access because `.zshrc` bootstraps Zinit automatically and downloads the configured plugins and Starship prompt.

## TTY default colors via GRUB kernel parameters

This example uses GRUB kernel parameters. Other bootloaders like systemd-boot or Limine require setting the equivalent kernel command line in their own configuration.

- `GRUB_CMDLINE_LINUX="vt.default_red=24,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=24,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=37,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"`

## Multiple monitors configuration hyprland
```
monitor=DP-3,1920x1080@60,0x0,1
monitor=HDMI-A-1,2560x1440@120,1920x0,1
monitor=DP-1,2560x1440@70,4480x0,1,transform,3
```
