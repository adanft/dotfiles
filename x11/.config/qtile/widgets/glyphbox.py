from libqtile import bar
from libqtile.widget import base


class GlyphBox(base._TextBox):
    defaults = [
        ("font", "sans", "Text font"),
        ("fontsize", None, "Font pixel size."),
        ("fontshadow", None, "Font shadow color."),
        ("padding", 0, "Padding left and right."),
        ("foreground", "#ffffff", "Foreground color."),
        ("background", None, "Background color."),
        ("y_offset", 0, "Vertical offset in pixels."),
    ]

    def __init__(self, text=" ", width=bar.CALCULATED, **config):
        base._TextBox.__init__(self, text=text, width=width, **config)
        self.add_defaults(GlyphBox.defaults)

    def draw(self):
        if self.background:
            self.drawer.clear(self.background)
        else:
            self.drawer.clear(self.bar.background)

        self.layout.text = self.text
        self.layout.colour = self.foreground
        y = int((self.bar.height - self.layout.height) / 2 + self.y_offset)
        self.layout.draw(self.padding, y)
        self.draw_at_default_position()
