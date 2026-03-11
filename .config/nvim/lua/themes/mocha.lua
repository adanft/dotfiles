local M = {}

local colors = {
  transparent = "NONE", --transparent
  bg = "#1e1e2e", -- base
  bg_alt = "#181825", -- mantle
  bg_soft = "#313244", -- surface0
  fg = "#cdd6f4", -- text
  fg_soft = "#bac2de", -- subtext1
  muted = "#6c7086", -- overlay0
  pink = "#f5c2e7", -- pink
  purple = "#cba6f7", -- mauve
  magenta = "#eba0ac", -- maroon
  blue = "#89b4fa", -- blue
  cyan = "#89dceb", -- sky
  green = "#a6e3a1", -- green
  yellow = "#f9e2af", -- yellow
  orange = "#fab387", -- peach
  red = "#f38ba8", -- red
}

M.theme = {
  normal = {
    a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
    b = { fg = colors.blue, bg = colors.bg_soft },
    c = { fg = colors.fg_soft, bg = colors.transparent },
  },
  terminal = {
    a = { fg = colors.bg, bg = colors.green, gui = "bold" },
    b = { fg = colors.green, bg = colors.bg_soft },
    c = { fg = colors.fg_soft, bg = colors.transparent },
  },
  insert = {
    a = { fg = colors.bg, bg = colors.cyan, gui = "bold" },
    b = { fg = colors.cyan, bg = colors.bg_soft },
    c = { fg = colors.fg_soft, bg = colors.transparent },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.purple, gui = "bold" },
    b = { fg = colors.purple, bg = colors.bg_soft },
    c = { fg = colors.fg_soft, bg = colors.transparent },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.red, gui = "bold" },
    b = { fg = colors.red, bg = colors.bg_soft },
    c = { fg = colors.fg_soft, bg = colors.transparent },
  },
  command = {
    a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
    b = { fg = colors.yellow, bg = colors.bg_soft },
    c = { fg = colors.fg_soft, bg = colors.transparent },
  },
  inactive = {
    a = { fg = colors.muted, bg = colors.bg_alt },
    b = { fg = colors.muted, bg = colors.bg_alt, gui = "bold" },
    c = { fg = colors.muted, bg = colors.transparent },
  },
}
return M
