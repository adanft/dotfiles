return {
  "mason-org/mason.nvim",
  build = ":MasonUpdate",
  opts = {
    tools = {
      "stylua",
      "shfmt",
      "biome",
    },
    ui = {
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ",
      },
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("mason").setup {
      ui = opts.ui,
    }

    local mr = require "mason-registry"
    mr.refresh(function()
      for _, tool in ipairs(opts.tools or {}) do
        local ok, pkg = pcall(mr.get_package, tool)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end)
  end,
}
