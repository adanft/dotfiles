return {
  "saghen/blink.cmp",
  dependencies = { "saghen/blink.lib", "rafamadriz/friendly-snippets" },
  build = function()
    require("blink.cmp").build():pwait()
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "enter" },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = { auto_show = true, window = {
        border = "rounded",
        scrollbar = false,
      } },
      list = {
        selection = {
          preselect = false,
        },
      },
      menu = {
        border = "rounded",
        scrollbar = false,
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
