# adanft dotfiles

A clean, practical Arch Linux desktop built around **Hyprland**, **Waybar**, **Rofi**, **Zsh**, **Tmux**, and modern terminal tooling. The goal is not to install every possible tool: it installs a focused working environment with enough pieces to start coding, navigating, launching apps, taking screenshots, managing sessions, and using a polished Wayland desktop immediately.

These dotfiles are designed to be copied into the target system, not symlinked to this repository. After installation, the machine keeps working even if the repository is deleted.

## Screenshots

Add these images to the repository when they are ready:

| Image | Suggested file name | Purpose |
| --- | --- | --- |
| Full desktop | `docs/images/desktop.png` | Main screenshot for the final desktop look. |
| Waybar close-up | `docs/images/waybar.png` | Shows modules, spacing, icons, and profile layout. |
| Rofi launcher | `docs/images/rofi-launcher.png` | Shows the app launcher theme. |
| Rofi power menu | `docs/images/rofi-power-menu.png` | Shows shutdown/reboot/lock/suspend menu. |
| Terminal/Tmux | `docs/images/terminal-tmux.png` | Shows shell, prompt, tmux status, and terminal theme. |

Create the directory with:

```sh
mkdir -p docs/images
```

## What this setup includes

| Area | Tools/configs |
| --- | --- |
| Window manager | Hyprland Lua config, portable monitor defaults, workspace rules, keybindings. |
| Bar | Waybar with profile-specific layouts for laptop, desktop, and VM. |
| Launcher/menus | Rofi launcher, screenshot menu, and profile-aware power menu. |
| Shell | Zsh, Starship, Zinit bootstrap, `$HOME/.local/bin` in PATH. |
| Terminal workflow | Ghostty, Kitty, Alacritty, Tmux, Yazi, Fastfetch. |
| Notifications | SwayNC. |
| Lock/idle/wallpaper | Hyprlock, Hypridle, Hyprpaper. |
| Login/boot visuals | Greetd/Tuigreet and Plymouth custom theme. |
| Screenshots/clipboard | Grim, Slurp, wl-clipboard, IMV. |
| Networking | NetworkManager and `nmtui` integration from Waybar. |

## Why this is a good base

- **Minimal but complete**: it avoids random extras while still providing a working daily desktop.
- **Profile-aware**: laptops, desktops, and VMs get different power, Waybar, and service behavior.
- **Safe install model**: existing files are backed up before replacement; unknown files are not deleted.
- **Portable runtime**: configs are copied into `$HOME` and `/etc`, not symlinked to the repo.
- **Reviewable structure**: the installer is split into small stages under `scripts/stages/` and shared helpers under `scripts/lib/`.

## Requirements

- Arch Linux.
- A user account with `sudo` access.
- Internet access for package installation and first Zsh plugin bootstrap.
- A Nerd Font capable of rendering icons.
- `SF Pro Display` installed manually if you want the intended visual match.

SF Pro Display is not vendored here. Install it separately from:

```text
https://github.com/chris-short/apple-san-francisco-pro-fonts
```

## Install

Run the installer from the repository root:

```sh
./install.sh
```

Preview the install without changing the machine:

```sh
./install.sh --dry-run
```

Avoid the interactive profile prompt by passing a profile explicitly:

```sh
./install.sh --profile laptop
./install.sh --profile desktop
./install.sh --profile vm
./install.sh --dry-run --profile vm
```

The installer must be run as your regular user, not as root. Privileged actions use `sudo` internally.

## Install safety model

| Case | Behavior |
| --- | --- |
| Destination directory already exists | Reuse it. |
| Destination directory does not exist | Create it with `mkdir -p`. |
| A file/symlink blocks a required directory path | Stop with a clear error. |
| Destination file already matches the repo file | Do nothing. |
| Destination file differs | Move the existing file to a backup next to itself, then copy the repo file. |
| Unknown files in existing directories | Leave them untouched. |
| Cleanup of unknown files | Not performed. The installer does not claim ownership of unknown files. |

Backup example:

```text
~/.config/rofi/scripts/power-menu.sh
~/.config/rofi/scripts/power-menu.backup.20260516-073726-753657909.sh
```

## Profiles

All profiles install the shared Hyprland desktop base. The differences are only where the machine type needs different behavior.

| Area | Desktop | Laptop | VM |
| --- | --- | --- | --- |
| Extra packages | `blueman`, `power-profiles-daemon` | `blueman`, `brightnessctl`, `power-profiles-daemon` | None |
| Waybar Wi-Fi | Yes, `wlan0` | Yes, `wlan0` | No |
| Waybar LAN | Yes | Yes | Yes |
| Waybar Bluetooth | Yes | Yes | No |
| Waybar battery | No | Yes | No |
| Waybar backlight | No | Yes, `intel_backlight` | No |
| Waybar power profile | Yes | Yes | No |
| Hypridle lock | Yes | Yes | Yes |
| Hypridle dim screen | No | Yes | No |
| Hypridle DPMS | Yes | Yes | No |
| Hypridle suspend | Yes | Yes | No |
| Rofi suspend option | Yes | Yes | No |
| Rofi power menu columns | 5 | 5 | 4 |
| Services | NetworkManager, greetd, power profiles, Bluetooth | NetworkManager, greetd, power profiles, Bluetooth | NetworkManager, greetd |

The VM profile is intentionally conservative: no suspend, no Bluetooth, no power profiles, no battery/backlight modules, and no Wi-Fi module in Waybar.

## Packages installed by the installer

### Shared packages

```text
hyprland xdg-desktop-portal-hyprland waybar rofi thunar
ghostty alacritty kitty zsh starship tmux neovim yazi fastfetch
hyprpaper hypridle hyprlock hyprpicker swaync wireplumber
polkit-gnome greetd greetd-tuigreet plymouth grim slurp imv
wl-clipboard jq libnotify which xdg-user-dirs networkmanager git
bat fzf lsd zoxide ttf-iosevkaterm-nerd ttf-nerd-fonts-symbols
```

### Profile packages

| Profile | Extra packages |
| --- | --- |
| `desktop` | `blueman`, `power-profiles-daemon` |
| `laptop` | `blueman`, `brightnessctl`, `power-profiles-daemon` |
| `vm` | None |

Some tools are intentionally not listed as explicit packages when another package should bring them as a dependency. For example, `playerctl` is verified because Hyprland media key bindings use it, but it is expected to come from Waybar's dependency chain.

## What gets copied

| Source | Destination |
| --- | --- |
| `.config/swaync` | `~/.config/swaync` |
| `.config/ghostty` | `~/.config/ghostty` |
| `.config/alacritty` | `~/.config/alacritty` |
| `.config/kitty` | `~/.config/kitty` |
| `.config/starship` | `~/.config/starship` |
| `.config/fastfetch` | `~/.config/fastfetch` |
| `.tmux` | `~/.tmux` |
| `.tmux.conf` | `~/.tmux.conf` |
| `.zshrc` | `~/.zshrc` |
| `Wallpapers` | `~/Wallpapers` |
| `.face` | `~/.face` |

Profile-specific files are copied into normal runtime paths:

| Profile source | Runtime destination |
| --- | --- |
| `.config/hypr/profiles/<profile>/hypridle.conf` | `~/.config/hypr/hypridle.conf` |
| `.config/waybar/profiles/<profile>/config.jsonc` | `~/.config/waybar/config.jsonc` |
| `.config/rofi/scripts/power-menu.sh` or `power-menu-vm.sh` | `~/.config/rofi/scripts/power-menu.sh` |
| Generated Rofi power theme | `~/.config/rofi/themes/power-menu.rasi` |

## System files and services

The installer also handles:

| Source | Destination |
| --- | --- |
| `greetd/config.toml` | `/etc/greetd/config.toml` |
| `greetd/start` | `/etc/greetd/start` |
| `plymouth/custom.plymouth` | `/usr/share/plymouth/themes/custom/custom.plymouth` |
| `plymouth/custom.script` | `/usr/share/plymouth/themes/custom/custom.script` |
| `plymouth/logo.png` | `/usr/share/plymouth/themes/custom/logo.png` |
| `plymouth/spinner.png` | `/usr/share/plymouth/themes/custom/spinner.png` |

It asks before enabling services during a real install:

| Service | Profiles |
| --- | --- |
| `NetworkManager.service` | all profiles |
| `greetd.service` | all profiles |
| `power-profiles-daemon.service` | desktop, laptop |
| `bluetooth.service` | desktop, laptop |

Plymouth is set to the custom theme. The installer warns if `/etc/mkinitcpio.conf` does not include the `plymouth` hook and asks before running:

```sh
sudo mkinitcpio -P
```

## Bootloader notes for TTY colors and Plymouth

The repo includes a TTY color palette as kernel parameters. Add the parameters to your bootloader command line if you want the same TTY colors.

```text
vt.default_red=24,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=24,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=37,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200
```

### GRUB

Edit `/etc/default/grub` and append the values to `GRUB_CMDLINE_LINUX`:

```sh
GRUB_CMDLINE_LINUX="vt.default_red=24,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=24,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=37,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
```

Then regenerate GRUB config:

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### systemd-boot

Edit your loader entry under `/boot/loader/entries/*.conf` and append the values to the `options` line:

```text
options root=... rw quiet splash vt.default_red=... vt.default_grn=... vt.default_blu=...
```

### Limine

Edit your Limine entry and append the values to the kernel command line, usually the `CMDLINE=` line:

```text
CMDLINE=root=... rw quiet splash vt.default_red=... vt.default_grn=... vt.default_blu=...
```

For Plymouth, make sure your initramfs uses the `plymouth` hook. On Arch with `mkinitcpio`, that means adding `plymouth` to `HOOKS` in `/etc/mkinitcpio.conf`, then running:

```sh
sudo mkinitcpio -P
```

## Hyprland keybindings

Main modifier: `SUPER`.

| Keybinding | Action |
| --- | --- |
| `SUPER + Return` | Open Ghostty. |
| `SUPER + Shift + Return` | Open Kitty. |
| `SUPER + Q` | Close focused window. |
| `SUPER + F` | Toggle fullscreen. |
| `SUPER + Space` | Toggle floating mode. |
| `SUPER + P` | Toggle pseudo tiling. |
| `SUPER + J` | Toggle split direction. |
| `SUPER + Tab` | Run layout toggle script. |
| `SUPER + E` | Open Thunar. |
| `SUPER + D` | Open Rofi launcher. |
| `SUPER + X` | Open Rofi power menu. |
| `SUPER + Shift + P` | Open Hyprpicker color picker. |
| `Print` | Open screenshot menu. |
| `SUPER + Left/Right/Up/Down` | Focus window in that direction. |
| `SUPER + 1..9` | Switch to workspace 1..9. |
| `SUPER + Shift + 1..9` | Move focused window to workspace 1..9. |
| `SUPER + Ctrl + Left/Right` | Focus previous/next workspace using helper script. |
| `SUPER + Ctrl + Shift + Left/Right` | Move focused window to previous/next workspace using helper script. |
| `SUPER + S` | Toggle special workspace `magic`. |
| `SUPER + Shift + S` | Move focused window to special workspace `magic`. |
| `SUPER + Mouse wheel` | Switch workspaces. |
| `SUPER + Left mouse drag` | Move window. |
| `SUPER + Right mouse drag` | Resize window. |
| `SUPER + Ctrl + Left mouse drag` | Resize window. |
| `XF86AudioRaiseVolume` | Increase volume with `wpctl`. |
| `XF86AudioLowerVolume` | Decrease volume with `wpctl`. |
| `XF86AudioMute` | Toggle output mute. |
| `XF86AudioMicMute` | Toggle microphone mute. |
| `XF86AudioNext` | Next media item with `playerctl`. |
| `XF86AudioPause` | Play/pause media with `playerctl`. |
| `XF86AudioPlay` | Play/pause media with `playerctl`. |
| `XF86AudioPrev` | Previous media item with `playerctl`. |

Laptop brightness keybindings are included as commented examples in `hyprland.lua`; enable them if your laptop backlight device works with `brightnessctl`.

## Hyprland monitor layout

The default monitor rule is portable:

```lua
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })
```

That works well for laptops, VMs, and changing monitor setups. A fixed three-monitor example is kept commented in `.config/hypr/hyprland.lua`; enable and edit it only when you know your real output names from:

```sh
hyprctl monitors
```

## Tmux after installation

The installer installs `tmux` and copies the tracked configuration. Plugins are intentionally installed on the target machine through TPM.

Install TPM if needed:

```sh
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Open tmux:

```sh
tmux
```

Install plugins:

```text
Ctrl-a + I
```

Useful tmux bindings:

| Binding | Action |
| --- | --- |
| `Ctrl-a` | Prefix key. |
| `Ctrl-a r` | Reload tmux config. |
| `Ctrl-a v` | Split pane horizontally in the current directory. |
| `Ctrl-a d` | Split pane vertically in the current directory. |
| `Ctrl-a x` | Ask before killing current pane. |
| `Ctrl-a &` | Ask before killing current window. |
| `Ctrl-a K` | Ask before killing current session. |
| Copy mode `y` | Copy selection through tmux clipboard integration. |

Configured plugins:

```text
tmux-plugins/tpm
tmux-plugins/tmux-resurrect
tmux-plugins/tmux-yank
christoomey/vim-tmux-navigator
alexwforsythe/tmux-which-key
```

The shell does not auto-start tmux. Start it manually when you want it:

```sh
tmux
```

## Zsh

The installer copies `.zshrc`, attempts to set Zsh as the default shell when possible, and keeps `$HOME/.local/bin` in `PATH`.

First Zsh startup needs internet access because `.zshrc` bootstraps Zinit and downloads the configured plugins and Starship prompt.

## Neovim

The installer installs the `neovim` binary only. It does not copy or manage a Neovim configuration.

Use your own Neovim configuration if you want one. This keeps the desktop installer focused and avoids forcing editor preferences onto the machine.

## After installation checklist

1. Reboot or log out/in if Zsh, Greetd, or Plymouth changes need to apply.
2. Install SF Pro Display manually if you want the intended font match.
3. Install Tmux plugins with TPM using `Ctrl-a + I` inside tmux.
4. If using Plymouth, confirm the `plymouth` hook exists in `/etc/mkinitcpio.conf` and run `sudo mkinitcpio -P` when ready.
5. Add bootloader kernel parameters if you want the TTY color palette.
6. Add screenshots under `docs/images/` using the suggested names above.
