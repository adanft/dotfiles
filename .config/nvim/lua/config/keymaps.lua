local map = vim.keymap.set

map({ "n", "v" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true, timeout_ms = 500 }
end, { desc = "Format file" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>cd", "<cmd>CodeDiff<CR>", { desc = "Git diff changes" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fe", "<cmd>Yazi<CR>", { desc = "Open yazi" })
map({ "n", "t" }, "<M-i>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
map({ "n", "i", "v" }, "<C-s>", function() vim.cmd("w") vim.notify("File saved", vim.log.levels.INFO) end, { desc = "Save File" })

-- Session persistence
map("n", "<leader>sl", function() require("persistence").load() end, { desc = "Restore Session" })
map("n", "<leader>ss", function() require("persistence").select() end, { desc = "Select Session" })
map("n", "<leader>sL", function() require("persistence").load { last = true } end, { desc = "Restore Last Session" })
map("n", "<leader>sx", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })

-- Comments
map("n", "<C-/>", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<C-/>", "gc",  { desc = "Toggle Comment", remap = true })

-- Select all
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })

-- Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
