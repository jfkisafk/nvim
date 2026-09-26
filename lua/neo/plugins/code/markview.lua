return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    preview = {
      filetypes = { "markdown" },
      ignore_buftypes = {},
    },
  },
  keys = {
    { "<leader>mp", "<cmd>Markview splitToggle<CR>", desc = "Toggle markdown preview" },
  },
}
