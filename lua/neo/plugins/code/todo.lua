return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    {
      "<leader>st",
      function()
        Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
      end,
      desc = "Todo/Fix/Fixme",
    },
    { "<leader>lt", "<cmd>TodoLocList<CR>",                                    desc = "Todo/Fix/Fixme" },
    { "<leader>qt", "<cmd>TodoQuickFix<CR>",                                   desc = "Todo/Fix/Fixme" },
    { "<leader>xt", "<cmd>Trouble todo filter = {tag = {TODO,FIX,FIXME}}<CR>", desc = "Todo/Fix/Fixme" },
  },
}
