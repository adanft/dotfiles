# Qtile keys

from libqtile.config import Key
from libqtile.lazy import lazy
import os

mod = "mod4"
menu = "rofi -show drun -theme ~/.config/rofi/themes/launcher.rasi"

home = os.path.expanduser('~')
terminal = 'alacritty'
color_picker = home + '/.config/qtile/scripts/qtile_colorpicker'
file_manager = 'thunar'
powermenu = home + "/.config/rofi/scripts/power-menu.sh"
notify_cmd = 'dunstify -u low -h string:x-dunst-stack-tag:qtileconfig'

keys = [
    # Terminal --
    Key(
        [mod], "Return",
        lazy.spawn(terminal),
        desc="Launch terminal with qtile configs"
    ),
    Key(
        [mod, "shift"], "Return",
        lazy.spawn(terminal + ' --class alacritty-float,alacritty-float'),
        desc="Launch floating terminal with qtile configs"
    ),

    # GUI Apps --
    Key(
        [mod], "e",
        lazy.spawn(file_manager),
        desc="Launch file manager"
    ),

    # Rofi Applets --a
    Key(
        [mod], "d",
        lazy.spawn(menu),
        desc="Run application launcher"
    ),
    Key(
        [mod], "x",
        lazy.spawn(powermenu),
        desc="Run powermenu applet"
    ),

    # Function keys : Volume --
    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+'),
        desc="Raise speaker volume"
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'),
        desc="Lower speaker volume"
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'),
        desc="Toggle mute"
    ),
    Key(
        [], "XF86AudioMicMute",
        lazy.spawn('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'),
        desc="Toggle mute for mic"
    ),
    
    # Function keys : Brightness --
    Key(
        [], "XF86MonBrightnessUp",
        lazy.spawn('brightnessctl -e4 -n2 set 5%+'),
        desc="Increase display brightness"
    ),
    Key(
        [], "XF86MonBrightnessDown",
        lazy.spawn('brightnessctl -e4 -n2 set 5%-'),
        desc="Decrease display brightness"
    ),

    # Misc --
    Key(
        [mod], "p",
        lazy.spawn(color_picker),
        desc="Run colorpicker"
    ),

    # WM Specific --
    Key(
        [mod], "q",
        lazy.window.kill(),
        desc="Kill focused window"
    ),

    # Control Qtile
    Key(
        [mod, "control"], "r",
        lazy.reload_config(),
        lazy.spawn(notify_cmd + ' "Configuration Reloaded!"'),
        desc="Reload the config"
    ),
    Key(
        [mod, "control"], "s",
        lazy.restart(),
        lazy.spawn(notify_cmd + ' "Restarting Qtile..."'),
        desc="Restart Qtile"
    ),

    # Switch between windows
    Key(
        [mod], "Left",
        lazy.layout.left(),
        desc="Move focus to left"
    ),
    Key(
        [mod], "Right",
        lazy.layout.right(),
        desc="Move focus to right"
    ),
    Key(
        [mod], "Down",
        lazy.layout.down(),
        desc="Move focus down"
    ),
    Key(
        [mod], "Up",
        lazy.layout.up(),
        desc="Move focus up"
    ),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "Left",
        lazy.layout.shuffle_left(),
        desc="Move window to the left"
    ),
    Key(
        [mod, "shift"], "Right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right"
    ),
    Key(
        [mod, "shift"], "Down",
        lazy.layout.shuffle_down(),
        desc="Move window down"
    ),
    Key(
        [mod, "shift"], "Up",
        lazy.layout.shuffle_up(),
        desc="Move window up"
    ),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [mod, "mod1"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        desc="Grow window to the left"
    ),
    Key(
        [mod, "mod1"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        desc="Grow window to the right"
    ),
    Key(
        [mod, "mod1"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        desc="Grow window down"
    ),
    Key(
        [mod, "mod1"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        desc="Grow window up"
    ),
    Key(
        [mod, "mod1"], "Return",
        lazy.layout.normalize(),
        lazy.layout.reset(),
        desc="Reset all window sizes"
    ),

    # Toggle floating and fullscreen
    Key(
        [mod], "space",
        lazy.window.toggle_floating(),
        desc="Put the focused window to/from floating mode"
    ),
    Key(
        [mod], "f",
        lazy.window.toggle_fullscreen(),
        desc="Put the focused window to/from fullscreen mode"
    ),

    # Go to next/prev group
    Key(
        [mod, "control"], "Right",
        lazy.screen.next_group(),
        desc="Move to the group on the right"
    ),
    Key(
        [mod, "control"], "Left",
        lazy.screen.prev_group(),
        desc="Move to the group on the left"
    ),

    # Back-n-forth groups
    Key(
        [mod], "b",
        lazy.screen.toggle_group(),
        desc="Move to the last visited group"
    ),

    # Change focus to other window
    Key(
        [mod], "Tab",
        lazy.next_layout(),
        desc="Toggle below layouts."
    ),
]
