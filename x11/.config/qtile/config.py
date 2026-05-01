import os
import subprocess

from libqtile import hook, layout
from libqtile.config import Click, Drag, IdleInhibitor, Match, Rule
from libqtile.lazy import lazy

from bar import extension_defaults, screens, widget_defaults
from keys import groups, keys, mod
from themes.catppuccin import colors


@hook.subscribe.startup
def autostart():
    subprocess.Popen([os.path.expanduser("~/.config/qtile/autostart.sh")])


layouts = [
    layout.Columns(
        border_focus=colors["blue"],
        border_focus_stack=[colors["blue"], colors["lavender"]],
        border_normal=colors["surface0"],
        border_width=1,
        margin=4,
    ),
]

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Drag(
        [mod, "control"], "Button1", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules: list[Rule] = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=colors["mauve"],
    border_normal=colors["surface0"],
    border_width=1,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True

auto_minimize = True

wl_input_rules = None

wl_xcursor_theme = None
wl_xcursor_size = 24

idle_inhibitors: list[IdleInhibitor] = []

wmname = "LG3D"
