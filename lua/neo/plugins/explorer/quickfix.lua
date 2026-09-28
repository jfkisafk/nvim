return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  opts = {
    borders = {
      vert = " ┃ ",
      strong_header = "━",
      strong_cross = "╋",
      strong_end = "┫",
      soft_header = "╌",
      soft_cross = "╂",
      soft_end = "┨",
    },
    keys = {
      {
        ">",
        function()
          require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
  },
  keys = {
    {
      "<leader>qf",
      function()
        require("quicker").toggle()
      end,
      desc = "Toggle quickfix",
    },
    {
      "<leader>ql",
      function()
        require("quicker").toggle({ loclist = true })
      end,
      desc = "Toggle loclist",
    },
  },
}
