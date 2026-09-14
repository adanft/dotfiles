return {
  "mason-org/mason.nvim",
  build = ":MasonUpdate",
  opts = {
    ui = {
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ",
      },
      border = "rounded",
    },
  },
}
