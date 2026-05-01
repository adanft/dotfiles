import os

from libqtile.config import Group, Key
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


# Custom functions for moving windows between workspaces
@lazy.function
def _window_to_next_group(qtile):
    if qtile.current_window is None:
        return

    groups = qtile.groups
    current = qtile.current_group
    idx = groups.index(current)
    next_idx = (idx + 1) % len(groups)
    qtile.current_window.togroup(groups[next_idx].name, switch_group=True)


@lazy.function
def _window_to_prev_group(qtile):
    if qtile.current_window is None:
        return

    groups = qtile.groups
    current = qtile.current_group
    idx = groups.index(current)
    prev_idx = (idx - 1) % len(groups)
    qtile.current_window.togroup(groups[prev_idx].name, switch_group=True)


mod = "mod4"
terminal = guess_terminal()
home = os.path.expanduser("~")
launcher = f"rofi -show drun -theme {home}/.config/rofi/themes/launcher.rasi"
power_menu = f"{home}/.config/rofi/scripts/power-menu.sh"
screenshot = f"{home}/.config/rofi/scripts/screenshot.sh"
colorpicker = "xcolor -s clipboard"


keys = [
    # ============================================
    # Hardware Controls
    # ============================================
    # Brightness
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-"), desc="Decrease brightness"),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%"), desc="Increase brightness"),
    # Volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+"), desc="Increase volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-"), desc="Decrease volume"),
    Key([], "XF86AudioMute", lazy.spawn("amixer sset Master toggle"), desc="Mute/unmute volume"),
    Key([], "XF86AudioMicMute", lazy.spawn("amixer sset Capture toggle"), desc="Mute/unmute microphone"),

    # ============================================
    # Window Focus Movement
    # ============================================
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    # ============================================
    # Window Movement Between Panes
    # ============================================
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # ============================================
    # Window Resizing
    # ============================================
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # ============================================
    # Window Management
    # ============================================
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "space", lazy.window.toggle_floating(), desc="Toggle floating"),

    # ============================================
    # Applications
    # ============================================
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "d", lazy.spawn(launcher), desc="Launch rofi app launcher"),
    Key([mod], "x", lazy.spawn(power_menu), desc="Launch rofi power menu"),
    Key([], "Print", lazy.spawn(screenshot), desc="Launch rofi screenshot menu"),
    Key([mod, "shift"], "p", lazy.spawn(colorpicker), desc="Launch color picker"),
    Key([mod], "e", lazy.spawn("thunar"), desc="Launch file explorer"),

    # ============================================
    # Workspace Navigation
    # ============================================
    Key([mod, "control"], "Right", lazy.screen.next_group(), desc="Next workspace"),
    Key([mod, "control"], "Left", lazy.screen.prev_group(), desc="Previous workspace"),
    Key([mod, "control", "shift"], "Right", _window_to_next_group(), desc="Move window to next workspace"),
    Key([mod, "control", "shift"], "Left", _window_to_prev_group(), desc="Move window to previous workspace"),

    # ============================================
    # Qtile Control
    # ============================================
    Key([mod, "control", "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]


# ============================================
# Groups (Workspaces)
# ============================================
groups = [Group(i, label="") for i in "12345"]

for group in groups:
    keys.extend(
        [
            Key(
                [mod],
                group.name,
                lazy.group[group.name].toscreen(),
                desc=f"Switch to group {group.name}",
            ),
            Key(
                [mod, "shift"],
                group.name,
                lazy.window.togroup(group.name, switch_group=True),
                desc=f"Switch to & move focused window to group {group.name}",
            ),
        ]
    )
