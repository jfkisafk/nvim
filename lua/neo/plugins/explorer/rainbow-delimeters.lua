return {
  "HiPhish/rainbow-delimiters.nvim",
  submodules = false,
  event = "BufReadPost",
  config = function()
    local p = require("rose-pine.palette")

    vim.api.nvim_set_hl(0, "RainbowDelimiterRose", { fg = p.rose })
    vim.api.nvim_set_hl(0, "RainbowDelimiterPine", { fg = p.pine })
    vim.api.nvim_set_hl(0, "RainbowDelimiterFoam", { fg = p.foam })
    vim.api.nvim_set_hl(0, "RainbowDelimiterIris", { fg = p.iris })
    vim.api.nvim_set_hl(0, "RainbowDelimiterGold", { fg = p.gold })
    vim.api.nvim_set_hl(0, "RainbowDelimiterLove", { fg = p.love })

    require("rainbow-delimiters.setup").setup({
      highlight = {
        "RainbowDelimiterRose",
        "RainbowDelimiterPine",
        "RainbowDelimiterFoam",
        "RainbowDelimiterIris",
        "RainbowDelimiterGold",
        "RainbowDelimiterLove",
      },
    })
  end,
}
