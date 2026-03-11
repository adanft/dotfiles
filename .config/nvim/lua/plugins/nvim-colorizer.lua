return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    user_default_options = {
      names = false,
      mode = "virtualtext",
      virtualtext_inline = true,
      virtualtext = "󱓻 ",
      tailwind = true,
    },
  },
}
