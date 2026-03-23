vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.number = true
opt.relativenumber = true
opt.laststatus = 3
opt.undofile = true
opt.showmode = false
opt.cmdheight = 1
opt.updatetime = 250

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.softtabstop = 2
opt.smartindent = true

local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
