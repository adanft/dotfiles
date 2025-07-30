from libqtile import widget
from libqtile.lazy import lazy
from .theme import colors
from scripts.mic_script import get_mic_status, toggle_mic

font_size = 16
font_family = "SF Pro Display, Symbols Nerd Font"


def base(fg="text", bg="base"):
    return {"foreground": colors[fg], "background": colors[bg]}


def separator(bg="transparent"):
    return widget.Sep(background=colors[bg], linewidth=0, padding=6)


def text(fg="text", bg="base", text="?"):
    return widget.TextBox(
        **base(fg, bg), fontsize=font_size, text=text, font=font_family
    )


def powerline_left(fg="base"):
    return widget.TextBox(
        **base(bg="transparent", fg=fg),
        text="",
        fontsize=30,
        padding=0,
        font="Symbols Nerd Font",
    )


def powerline_right(fg="base"):
    return widget.TextBox(
        **base(bg="transparent", fg=fg),
        text="",
        fontsize=30,
        padding=0,
        font="Symbols Nerd Font",
    )


def workspaces():
    return [
        powerline_left("base"),
        widget.GroupBox(
            background=colors["base"],
            font=font_family,
            fontsize=font_size,
            margin_y=6,
            margin_x=0,
            padding_y=0,
            padding_x=4,
            borderwidth=3,
            active=colors["overlay2"],
            inactive=colors["inactive"],
            highlight_method="line",
            highlight_color=[colors["base"], colors["base"]],
            urgent_alert_method="text",
            urgent_text=colors["red"],
            this_current_screen_border=colors["focus"],
            this_screen_border=colors["overlay0"],
            other_current_screen_border=colors["base"],
            other_screen_border=colors["base"],
            block_highlight_text_color=colors["lavender"]
        ),
        powerline_right("base"),
        separator(),
        widget.WindowName(
            **base(fg="text", bg="transparent"),
            fontsize=font_size,
            font=font_family,
            fmt='<span weight="Semibold">{}</span>'
        ),
        widget.Spacer(length=6),
        powerline_left("base"),
        text(bg="base", fg="text", text="󱑂 "),
        widget.Clock(
            **base(bg="base", fg="text"),
            format='<span weight="Semibold">%H:%M</span>',
            font=font_family,
            fontsize=font_size
        ),
        powerline_right("base"),
        widget.Spacer(),
    ]


primary_widgets = [
    *workspaces(),
    widget.Systray(background=colors["transparent"], padding=6),
    separator(),
    powerline_left("base"),
    widget.Wlan(
        foreground=colors["red"],
        background=colors["base"],
        font=font_family,
        fontsize=font_size,
        disconnected_message='󰤭 <span weight="Semibold">0%</span>',
        format='󰤨 <span weight="Semibold">{percent:2.0%}</span>'
    ),
    separator("base"),
    widget.Net(
        interface='enp2s0',
        foreground=colors["blue"],
        background=colors["base"],
        font=font_family,
        fontsize=font_size,
        format='  <span weight="Semibold">{down:.0f}{down_suffix}  {up:.0f}{up_suffix} </span>',
    ),
    separator("base"),
    widget.Backlight(
        backlight_name="nvidia_wmi_ec_backlight",
        background=colors["base"],
        foreground=colors["yellow"],
        font=font_family,
        fontsize=font_size,
        format='󰃝 <span weight="Semibold">{percent:2.0%}</span>',
    ),
    separator("base"),
    widget.Battery(
        format='{char} <span weight="Semibold">{percent:2.0%}</span>',
        background=colors["base"],
        foreground=colors["blue"],
        font=font_family,
        fontsize=font_size,
        discharge_char='󰂍',
        charging_foreground=colors["sky"],
        low_foreground=colors["red"],
        charge_char='󰢝',
        empty_char='󱃍',
        full_char='󱃌',
        not_charging_char='󱉝',
        unknown_char='󰂑',
        full_short_text=' <span weight="Semibold">100%</span>'
    ),
    separator("base"),
    widget.Volume(
        background=colors["base"],
        foreground=colors["green"],
        font=font_family,
        fontsize=font_size,
        unmute_format=' <span weight="Semibold">{volume}%</span>',
        mute_format=' <span weight="Semibold">0%</span>',
    ),
    separator("base"),
    widget.GenPollText(
        func=get_mic_status,
        mouse_callbacks={'Button1': lambda: toggle_mic() },
        background=colors["base"],
        foreground=colors["mauve"],
        font=font_family,
        fontsize=font_size,
        update_interval=1
    ),
    separator("base"),
    widget.CurrentLayoutIcon(**base(bg="base"), scale=0.65),
    powerline_right("base"),
    separator(),
    powerline_left("base"),
    text(bg="base", fg="text", text="󰃭 "),
    widget.Clock(
        **base(bg="base", fg="text"),
        format='<span weight="Semibold">%d-%m</span>',
        font=font_family,
        fontsize=font_size
    ),
    powerline_right("base"),
]

def get_secondary_widgets():
    return [
        *workspaces(),
        separator(),
        powerline_left("base"),
        widget.CurrentLayout(**base(bg="base", fg="text"),
                             font=font_family, fontsize=font_size),
        widget.CurrentLayoutIcon(**base(bg="base", fg='text'), scale=0.65),
        powerline_right("base"),
        separator(),
        powerline_left("base"),
        text(bg="base", fg="text", text="󰃭 "),
        widget.Clock(
            **base(bg="base", fg="text"),
            format="%d-%m-%Y",
            font=font_family,
            fontsize=font_size
        ),
        powerline_right("base"),
    ]
