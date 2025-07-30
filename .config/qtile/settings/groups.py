from libqtile.config import Key, Group
from libqtile.lazy import lazy
from .keys import mod, keys

figure = ""

groups = [Group(i, label=figure) for i in "12345678"]


for i in groups:
    keys.extend(
        [
            # mod + number of group = switch to group
            Key(
                [mod], i.name, lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + number of group = switch to & move focused window to group
            Key(
                [mod, "shift"], i.name,
                lazy.window.togroup(i.name),
                desc="Switch to & move focused window to group {}".format(
                    i.name),
            ),
        ]
    )
