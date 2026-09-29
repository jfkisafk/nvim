return {
  "folke/persistence.nvim",
  -- Only start saving once a real file is opened, so a bare `nvim` doesn't overwrite the session.
  event = "BufReadPre",
  config = function(_, opts)
    require("persistence").setup(opts)

    -- Snacks explorer, notifier history, etc. are blank buffers that would restore empty.
    vim.opt.sessionoptions:remove("blank")
  end,
  keys = {
    { "<leader>ws", function() require("persistence").load() end, desc = "Restore session (cwd)" },
    { "<leader>wS", function() require("persistence").select() end, desc = "Select session" },
    { "<leader>wl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>wd", function() require("persistence").stop() end, desc = "Don't save current session" },
  },
}
