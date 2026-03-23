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

-- Custom tabline configuration

local catppuccin = require("catppuccin.palettes").get_palette()

vim.o.showtabline = 1

vim.api.nvim_set_hl(0, "TabLineSel", { fg = catppuccin.mauve, bg = catppuccin.base, bold = true })
vim.api.nvim_set_hl(0, "TabLine", { fg = catppuccin.surface2, bg = catppuccin.base })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = catppuccin.base })

function _G.MyTabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr "$" do
    local current = i == vim.fn.tabpagenr()
    local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
    local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
    name = name ~= "" and name or " Empty"

    s = s .. (current and "%#TabLineSel#" or "%#TabLine#")
    s = s .. "%" .. i .. "T"
    s = s .. " " .. name .. " "
  end
  return s .. "%#TabLineFill#%T"
end

vim.o.tabline = "%!v:lua.MyTabline()"
