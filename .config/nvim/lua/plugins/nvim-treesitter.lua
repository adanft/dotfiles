return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require "nvim-treesitter"

    ts.install {
      "bash",
      "html",
      "javascript",
      "tsx",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "vim",
      "vimdoc",
      "rust",
      "markdown_inline",
      "yaml",
      "dockerfile",
      "gitignore",
      "zsh",
      "tmux",
      "slint",
    }

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
