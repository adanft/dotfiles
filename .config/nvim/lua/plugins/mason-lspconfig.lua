return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = { "lua_ls", "ts_ls", "tailwindcss", "biome", "ruff" },
    automatic_enable = true,
  },
}
