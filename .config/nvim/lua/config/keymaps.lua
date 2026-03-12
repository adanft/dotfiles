local map = vim.keymap.set

map({ "n", "v" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true, timeout_ms = 500 }
end, { desc = "Format file" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fe", "<cmd>Yazi<CR>", { desc = "Open yazi" })
map({ "n", "t" }, "<C-t>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
map({ "n", "i", "v" }, "<C-s>", function() vim.cmd("w") vim.notify("File saved", vim.log.levels.INFO) end, { desc = "Save File" })

-- Session persistence
map("n", "<leader>sl", function() require("persistence").load() end, { desc = "Restore Session" })
map("n", "<leader>ss", function() require("persistence").select() end, { desc = "Select Session" })
map("n", "<leader>sL", function() require("persistence").load { last = true } end, { desc = "Restore Last Session" })
map("n", "<leader>sx", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })

-- Noice
map("n", "<leader>nl", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })
map("n", "<leader>nh", function() require("noice").cmd("history") end, { desc = "Noice History" })
map("n", "<leader>na", function() require("noice").cmd("all") end, { desc = "Noice All" })
map("n", "<leader>nd", function() require("noice").cmd("dismiss") end, { desc = "Noice Dismiss All" })
map("n", "<leader>nt", function() require("noice").cmd("pick") end, { desc = "Noice Picker" })

-- Comments
map("n", "<C-/>", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<C-/>", "gc",  { desc = "Toggle Comment", remap = true })

-- Select all
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })
