return {
  {
    "paulbkim-dev/vim-herdr-navigation",
    event = "VeryLazy",
    config = function(plugin)
      dofile(plugin.dir .. "/editor/nvim.lua")

      -- The plugin only maps normal mode; herdr forwards these keys to nvim in any mode.
      for _, lhs in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
        local map = vim.fn.maparg(lhs, "n", false, true)
        vim.keymap.set("x", lhs, map.callback, { silent = true, desc = map.desc })
      end
    end,
  },
}
