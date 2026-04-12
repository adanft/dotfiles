return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      sh = { "shfmt" },
      json = { "biome" },
      jsonc = { "biome" },
      javascript = { "biome" },
      javascriptreact = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      python = { "ruff_fmt" },
    },
    formatters = {
      ruff_fmt = {
        command = "ruff",
        args = { "format", "--stdin-filename", "$FILENAME", "-" },
        stdin = true,
      },
    },
  },
}
