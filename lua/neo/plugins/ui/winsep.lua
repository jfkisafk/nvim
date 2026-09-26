return {
  "nvim-zh/colorful-winsep.nvim",
  event = { "WinLeave" },
  config = function()
    local p = require("rose-pine.palette")
    require("colorful-winsep").setup({
      colors = { p.pine },
      animate = "progressive",
    })
  end,
}
