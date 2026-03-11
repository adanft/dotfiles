return {
  "neovim/nvim-lspconfig",
  config = function()
    local x = vim.diagnostic.severity
    local map = vim.keymap.set

    vim.diagnostic.config {
      virtual_text = { prefix = "" },
      signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
      underline = true,
      float = { border = "single" },
    }
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local function opts(desc)
          return { buffer = args.bufnr, desc = "LSP " .. desc }
        end

        map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
        map("n", "gr", vim.lsp.buf.references, opts "Go to references")
        map("n", "K", vim.lsp.buf.hover, opts "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, opts "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
        map("n", "<leader>of", vim.diagnostic.open_float, opts "Line diagnostics")
        map("n", "gD", vim.lsp.buf.declaration, opts "Go to Declaration")
        map("n", "gI", vim.lsp.buf.implementation, opts "Go to Implementation")
        map("n", "gy", vim.lsp.buf.type_definition, opts "Go to Type Definition")
        map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Signature Help")
        map("n", "[[", vim.diagnostic.goto_prev, opts "Prev diagnostic")
        map("n", "]]", vim.diagnostic.goto_next, opts "Next diagnostic")
      end,
    })
  end,
}
