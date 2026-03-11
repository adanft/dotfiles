return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = true,
    auto_integrations = true,
    float = {
      transparent = true,
      solid = false,
    },
    integrations = {
      telescope = {
        enabled = true,
      },
      which_key = true,
      mason = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme "catppuccin"
  end,
}
