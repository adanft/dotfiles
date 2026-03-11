return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      sh = { "shfmt" },
    },
  },
}
