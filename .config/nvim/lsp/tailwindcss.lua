return {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
        },
      },
    },
  },
}
