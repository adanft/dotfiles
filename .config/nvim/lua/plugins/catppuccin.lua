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
    custom_highlights = function(colors)
      return {
        Search = { bg = "#3d67d7", fg = "#c8d3f5", bold = true },
        IncSearch = { bg = "#ff007c", fg = "#c8d3f5", bold = true },
        Substitute = { bg = "#14dba6", fg = "#1e1e2e", bold = true },
        Visual = { bg = "#364151" },
        FlashMatch = { bg = "#3d67d7", fg = "#c8d3f5", bold = true },
        FlashCurrent = { bg = "#ff007c", fg = "#c8d3f5", bold = true },
        FlashLabel = { bg = "#14dba6", fg = "#1e1e2e", bold = true },
        FlashBackdrop = { fg = "#45475a" },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme "catppuccin"
  end,
}
