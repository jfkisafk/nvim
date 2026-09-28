return {
  "nvim-mini/mini.ai",
  version = false,
  event = "VeryLazy",
  -- Only for its textobjects.scm queries; mini.ai does the selecting.
  dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" } },
  config = function()
    local ai = require("mini.ai")
    local ts = ai.gen_spec.treesitter

    -- Built-ins cover a (argument), f (call), q (quote), b (bracket), t (tag).
    -- i is left to snacks' indent-scope textobject.
    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        m = ts({ a = "@function.outer", i = "@function.inner" }),
        c = ts({ a = "@class.outer", i = "@class.inner" }),
        o = ts({
          a = { "@conditional.outer", "@loop.outer", "@block.outer" },
          i = { "@conditional.inner", "@loop.inner", "@block.inner" },
        }),
        ["="] = ts({ a = "@assignment.outer", i = "@assignment.inner" }),
      },
    })
  end,
}
