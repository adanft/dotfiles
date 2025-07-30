-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font('CaskaydiaCove Nerd Font')
config.font_size = 12

config.enable_tab_bar = false
config.window_background_opacity = 0.95
config.cursor_blink_ease_out = 'Linear'
config.disable_default_key_bindings = true
config.keys = {
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.ResetFontSize
  },
  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize
  },
  {
    key = '+',
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize
  },
  {
    key = 'r',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ReloadConfiguration
  },
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = act.CopyTo("ClipboardAndPrimarySelection")
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = act.PasteFrom("Clipboard")
  },
}
-- and finally, return the configuration to wezterm
return config

