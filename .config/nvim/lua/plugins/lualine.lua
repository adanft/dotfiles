return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
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
          icon = "󰒋 ",
          symbols = {
            spinner = { "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥" },
            done = "󰄬",
          },
        },
        {
          function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          icon = " ",
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
