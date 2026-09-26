return {
  {
    "paulbkim-dev/vim-herdr-navigation",
    event = "VeryLazy",
    config = function()
      dofile(vim.fn.stdpath("data") .. "/lazy/vim-herdr-navigation/editor/nvim.lua")
    end,
  },
}
