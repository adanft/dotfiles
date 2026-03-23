local mocha = require("themes.mocha").theme

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    options = {
      theme = mocha,
      globalstatus = true,
    },
    sections = {
      lualine_a = {
        {
          "mode",
          icon = "",
        },
      },
      lualine_b = { { "branch", separator = "" }, { "diff", separator = "" }, "diagnostics" },
      lualine_c = {
        {
          "filetype",
          icon_only = true,
          separator = "",
          padding = { left = 1, right = 0 },
        },
        {
          "filename",
          symbols = {
            modified = "",
            readonly = "",
            unnamed = "Empty",
            newfile = "New",
          },
        },
      },
      lualine_x = {
        {
          "lsp_status",
          icon = { " " },
          color = { fg = "#89b4fa" },
          ignore_lsp = { "" },
          separator = "",
          symbols = {
            spinner = { "󱦟", "󰞌" },
            done = "",
            separator = " ",
          },
        },
        {
          function()
            return ""
          end,
          separator = "",
          color = { fg = "#e7c787" },
          padding = 0,
        },
        {
          function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          icon = " ",
          color = { fg = "#1e222a", bg = "#e7c787", gui = "bold" },
        },
      },
      lualine_y = {
        { "progress", separator = "", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return "  " .. os.date "%R"
        end,
      },
    },
  },
}

--component_separators = { left = '', right = ''},
--section_separators = { left = '', right = ''},
