return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  event = "BufEnter",
  opts = {
    references = { provider = "snacks" },
  },
  keys = {
    { "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Goto Preview Definition" },
    { "gx", "<cmd>lua require('goto-preview').close_all_win()<CR>",           desc = "Goto Preview Close" },
  },
}
