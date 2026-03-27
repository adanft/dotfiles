vim.opt.exrc = false
vim.opt.secure = true
vim.opt.modeline = false
vim.opt.clipboard = ""
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·" }
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- 2 spaces for yaml/toml/json
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "json", "toml" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- ===== Transparent background =====
vim.api.nvim_set_hl(0, "Normal",  { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

vim.keymap.set("n", "<leader>fe", "<cmd>Ex<cr>", { desc = "File explorer" })
