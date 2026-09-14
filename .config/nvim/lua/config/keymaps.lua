local map = vim.keymap.set

map({ "n", "v" }, "<leader>fm", function()
  require("conform").format { lsp_format = "fallback", timeout_ms = 500 }
end, { desc = "Format file" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>cd", "<cmd>CodeDiff<CR>", { desc = "Git diff changes" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fe", "<cmd>Yazi<CR>", { desc = "Open yazi" })
map({ "n", "t" }, "<M-i>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
map({ "n", "i", "v" }, "<C-s>", function() vim.cmd("w") vim.notify("File saved", vim.log.levels.INFO) end, { desc = "Save File" })

-- Buffers and exit
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit Neovim" })

-- Session persistence
map("n", "<leader>sl", function() require("config.session").load() end, { desc = "Restore Session" })

-- Select all
map('n', '<C-e>', 'ggVG', { desc = 'Select all' })

-- Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
