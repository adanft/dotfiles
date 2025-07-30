from libqtile import layout
from libqtile.config import Match
from .theme import colors

# Layouts and layout rules

layout_conf = {
    'border_focus': colors['focus'],
    'border_width': 2,
    'border_normal': colors["inactive"],
}

layouts = [
    # Layouts
    layout.Columns(
        **layout_conf,
        border_on_single=True,
        margin=3,
    ),
    layout.MonadTall(
        **layout_conf,
        single_border_width=2,
        margin=3,
    ),
    layout.Max(
        margin=3,
    ),
]

floating_layout = layout.Floating(
    border_focus=colors["yellow"],
    border_width=2,
    border_normal=colors["blue"],
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="alacritty-float"),
        Match(wm_class="thunar"),
        Match(wm_class="Lxappearance"),
        Match(wm_class="Nitrogen"),
        Match(wm_class="pwvucontrol"),
        Match(wm_class="Xfce4-power-manager-settings"),
        Match(wm_class="Nm-connection-editor"),
        Match(wm_class="feh"),
        Match(wm_class="Viewnior"),
        Match(wm_class="Gpicview"),
        Match(wm_class="Gimp"),
        Match(wm_class="MPlayer"),
        Match(wm_class="Vlc"),
        Match(wm_class="Spotify"),
        Match(wm_class="Kvantum Manager"),
        Match(wm_class="qt5ct"),
        Match(wm_class="qt6ct"),
        Match(wm_class="VirtualBox Manager"),
        Match(wm_class="qemu"),
        Match(wm_class="Qemu-system-x86_64"),
        Match(title="branchdialog"),
    ]
)
