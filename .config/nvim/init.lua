require "config.options"
require "config.keymaps"
require "config.lazy"

vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#cba6f7" })
vim.api.nvim_set_hl(1, "NoiceCmdlinePopupBorderSearch", { fg = "#89b4fa" })

-- Extra colors
vim.api.nvim_set_hl(0, "CurSearch", {
  bg = "#ff007c",
  fg = "#c8d3f5",
  bold = true,
})
