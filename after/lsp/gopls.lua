return {
  settings = {
    gopls = {
      completeUnimported = true,
      completeFunctionCalls = true,
      usePlaceholders = true,
      analyses = {
        nilness = true,
        unreachable = true,
        unusedparams = true,
        unusedvariable = true,
        unusedwrite = true,
      },
      formatting = {
        gofumpt = true,
      },
    },
  },
}
