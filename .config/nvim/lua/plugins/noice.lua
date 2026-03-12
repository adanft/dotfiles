return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function(_, opts)
    if vim.bo.filetype == "lazy" then
      vim.cmd "messages clear"
    end
    require("noice").setup(opts)
  end,
  opts = {
    input = {
      enabled = false,
    },
    commands = {
      all = {
        view = "popup",
        opts = { enter = true, format = "details" },
        filter = {},
      },
      history = {
        view = "popup",
        opts = { enter = true, format = "details" },
        filter = {},
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
    },
    cmdline = {
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "󱆃", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        input = { view = "cmdline_input", icon = "󰥻 " },
      },
    },
    views = {
      popup = {
        size = {
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.6),
        },
      },
    },
  },
}
