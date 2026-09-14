return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    auto_integrations = true,
    transparent_background = true,
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = "NONE" },
        FloatBorder = { fg = colors.blue, bg = "NONE" },
        FloatTitle = { fg = colors.blue, bg = "NONE" },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme "catppuccin"
  end,
}
