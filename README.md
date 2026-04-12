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

## Zsh setup
- Install `zsh`, `git`, `lsd`, `bat`, and `fzf`
- Change your default shell with `chsh -s $(which zsh)` and relog if needed
- Create and copy the `.zshrc` file if it does not exist
- Use a Nerd Font in your terminal

## TTY default colors via GRUB kernel parameters

This example uses GRUB kernel parameters. Other bootloaders like systemd-boot or Limine require setting the equivalent kernel command line in their own configuration.

- `GRUB_CMDLINE_LINUX="vt.default_red=24,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=24,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=37,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"`

## Multiple monitors configuration hyprland
```
monitor=DP-3,1920x1080@60,0x0,1
monitor=HDMI-A-1,2560x1440@120,1920x0,1
monitor=DP-1,2560x1440@70,4480x0,1,transform,3
```
