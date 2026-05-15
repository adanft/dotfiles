-----------------
-- Theme colors --
-----------------

local colors = {
  mauve = "rgb(cba6f7)",
  overlay0 = "rgb(6c7086)",
  base = "rgb(1e1e2e)",
}

--------------
-- Monitors --
--------------

-- Portable default: let Hyprland pick the connected display(s).
-- This works for desktops, laptops, and VMs without hardcoding output names.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

-- Optional: fixed multi-monitor layout.
-- Get output names with: hyprctl monitors
-- Format: output, mode, position, scale[, extra options]
-- hl.monitor({ output = "DP-3", mode = "1920x1080@60", position = "0x0", scale = "1" })
-- hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@120", position = "1920x0", scale = "1" })
-- hl.monitor({ output = "DP-1", mode = "2560x1440@75", position = "4480x0", scale = "1", transform = 3 })

-- Optional: workspace pinning for a fixed multi-monitor setup.
-- Keep disabled for one monitor, laptops with changing outputs, or VMs.
-- hl.workspace_rule({ workspace = "1", monitor = "DP-3" })
-- hl.workspace_rule({ workspace = "2", monitor = "DP-3" })
-- hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
-- hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "7", monitor = "DP-1" })
-- hl.workspace_rule({ workspace = "8", monitor = "DP-1" })
-- hl.workspace_rule({ workspace = "9", monitor = "DP-1" })

-------------
-- Aliases --
-------------

local terminal = "ghostty"
local secondary_terminal = "kitty"
local file_manager = "thunar"
local menu = "rofi -no-config -no-lazy-grab -show drun -modi drun -theme ~/.config/rofi/themes/launcher.rasi"
local picker = "hyprpicker -a"
local focus_workspace = "$HOME/.config/hypr/scripts/focus_workspace.sh"
local move_window_workspace = "$HOME/.config/hypr/scripts/move_window_workspace.sh"
local toggle_layout = "$HOME/.config/hypr/scripts/toggle_layout.sh"
local screenshot = "$HOME/.config/rofi/scripts/screenshot.sh"

-------------
-- Startup --
-------------

hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("swaync")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)

-----------------
-- Environment --
-----------------

hl.env("GTK_THEME", "Sweet-Ambar-Blue-Dark-v40")
hl.env("XCURSOR_THEME", "Sweet-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Sweet-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-------------------
-- Look and feel --
-------------------

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 6,
    border_size = 2,
    col = {
      active_border = colors.mauve,
      inactive_border = colors.overlay0,
    },
  },

  decoration = {
    rounding = 6,
    shadow = { enabled = false },
    blur = { enabled = false },
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  input = {
    accel_profile = "flat",
  },

  misc = {
    background_color = colors.base,
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})

----------------
-- Animations --
----------------

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1.00 }, { 0.32, 1.00 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1.00 } } })
hl.curve("linear", { type = "bezier", points = { { 0.00, 0.00 }, { 1.00, 1.00 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.50, 0.50 }, { 0.75, 1.00 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0.00 }, { 0.10, 1.00 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10.00, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.10, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4.00, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.50, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-------------
-- Keybinds --
-------------

local main_mod = "SUPER"

hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(secondary_terminal))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(main_mod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + TAB", hl.dsp.exec_cmd(toggle_layout))

hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + X", hl.dsp.exec_cmd("~/.config/rofi/scripts/power-menu-active.sh"))
hl.bind(main_mod .. " + SHIFT + P", hl.dsp.exec_cmd(picker))
hl.bind("Print", hl.dsp.exec_cmd(screenshot))

hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "d" }))

for i = 1, 9 do
  hl.bind(main_mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(main_mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(main_mod .. " + CTRL + left", hl.dsp.exec_cmd(focus_workspace .. " prev"))
hl.bind(main_mod .. " + CTRL + right", hl.dsp.exec_cmd(focus_workspace .. " next"))
hl.bind(main_mod .. " + CTRL + SHIFT + left", hl.dsp.exec_cmd(move_window_workspace .. " prev"))
hl.bind(main_mod .. " + CTRL + SHIFT + right", hl.dsp.exec_cmd(move_window_workspace .. " next"))

hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(main_mod .. " + CTRL + mouse:272", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

-- Laptop only: requires brightnessctl and a backlight device.
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

------------------
-- Window rules --
------------------

hl.window_rule({
  name = "float-class-floating",
  match = { class = "floating" },
  float = true,
})

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = "20 monitor_h-120",
  float = true,
})
