from pathlib import Path

from libqtile import bar, widget
from libqtile.config import Screen
from libqtile.lazy import lazy

from themes.catppuccin import colors
from widgets.glyphbox import GlyphBox


def separator_bg():
    return widget.TextBox(background=colors["surface0"])


def separator():
    return widget.TextBox()


def icon_box(text):
    return widget.TextBox(
        background=colors["surface0"],
        text=text,
        font="Symbols Nerd Font",
        fontsize=16,
        padding=0,
        foreground=colors["subtext0"],
    )


dunst_history_menu = f"{Path.home()}/.config/rofi/scripts/dunst-history.sh"


def left_glyph():
    return GlyphBox(
        text="",
        font="Symbols Nerd Font",
        fontsize=24,
        foreground=colors["surface0"],
        padding=0,
        y_offset=-1,
    )


def right_glyph():
    return GlyphBox(
        text="",
        font="Symbols Nerd Font",
        fontsize=24,
        foreground=colors["surface0"],
        padding=0,
        y_offset=-1,
    )


widget_defaults = {
    "font": "SF Pro Display; Bold",
    "fontsize": 14,
    "padding": 3,
    "foreground": colors["text"],
}
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                left_glyph(),
                widget.GroupBox(
                    font="Symbols Nerd Font",
                    fontsize=16,
                    active=colors["text"],
                    inactive=colors["surface2"],
                    margin_x=0,
                    margin_y=0,
                    padding_x=0,
                    padding_y=0,
                    spacing=4,
                    borderwidth=0,
                    highlight_method="text",
                    rounded=False,
                    background=colors["surface0"],
                    this_current_screen_border=colors["mauve"],
                ),
                right_glyph(),
                widget.WindowName(
                    empty_group_string="Qtile",
                    foreground=colors["subtext0"],
                ),
                left_glyph(),
                icon_box("󱑂"),
                widget.Clock(
                    format="%H:%M",
                    foreground=colors["subtext0"],
                    background=colors["surface0"],
                    padding=0,
                ),
                right_glyph(),
                widget.Spacer(),
                widget.Systray(),
                left_glyph(),
                widget.Wlan(
                    interface="wlan0",
                    format="<span font_desc='Symbols Nerd Font 12'>󰤥</span> {percent:2.0%}",
                    disconnected_message="<span font_desc='Symbols Nerd Font 12'>󰤮</span>",
                    update_interval=5,
                    markup=True,
                    foreground=colors["red"],
                    background=colors["surface0"],
                ),
                separator_bg(),
                widget.Volume(
                    unmute_format="<span font_desc='Symbols Nerd Font 12'></span> {volume}%",
                    mute_format="<span font_desc='Symbols Nerd Font 12'></span> 0%",
                    foreground=colors["mauve"],
                    background=colors["surface0"],
                ),
                separator_bg(),
                widget.Backlight(
                    backlight_name="intel_backlight",
                    format="<span font_desc='Symbols Nerd Font 12'>󰃠</span> {percent:2.0%}",
                    foreground=colors["yellow"],
                    background=colors["surface0"],
                    change_command="brightnessctl set {0:.0f}%",
                    step=5,
                ),
                separator_bg(),
                widget.Battery(
                    battery="BAT0",
                    format="<span font_desc='Symbols Nerd Font 12'>{char}</span> {percent:2.0%}",
                    charge_char="󰢝",
                    discharge_char="󰂂",
                    empty_char="󰂎",
                    full_char="󱃌",
                    low_percentage=0.20,
                    low_foreground=colors["red"],
                    charging_foreground=colors["blue"],
                    foreground=colors["green"],
                    background=colors["surface0"],
                    update_interval=10,
                ),
                separator_bg(),
                widget.TextBox(
                    background=colors["surface0"],
                    text="󰂚",
                    font="Symbols Nerd Font",
                    fontsize=16,
                    padding=0,
                    foreground=colors["flamingo"],
                    mouse_callbacks={"Button1": lazy.spawn(dunst_history_menu)},
                ),
                right_glyph(),
                separator(),
                left_glyph(),
                icon_box("󰃭"),
                widget.Clock(
                    format="%m-%d",
                    foreground=colors["subtext0"],
                    background=colors["surface0"],
                    padding=0,
                ),
                right_glyph(),
            ],
            24,
            background=colors["bar_background"],
            margin=[4, 4, 0, 4],
        ),
        background=colors["bar_background"],
    ),
]
