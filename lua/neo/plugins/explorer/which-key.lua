return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-mini/mini.icons", version = false },
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
}
