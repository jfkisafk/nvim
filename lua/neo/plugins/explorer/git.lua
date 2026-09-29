return {
  {
    "nvim-mini/mini.diff",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local minidiff = require("mini.diff")
      minidiff.setup({
        view = { style = "sign", signs = { add = "┃", change = "┃", delete = "▁" } },
        -- mini's maps are global and error outside enabled buffers; keep only reset and the textobject.
        mappings = { apply = "", goto_first = "", goto_prev = "", goto_next = "", goto_last = "", textobject = "ih" },
      })

      -- Act only in enabled buffers, as gitsigns' buffer-local maps did.
      local function in_diff_buf(fn, arg)
        return function()
          if minidiff.get_buf_data(0) then
            fn(arg)
          end
        end
      end

      vim.keymap.set({ "n", "x" }, "]h", in_diff_buf(minidiff.goto_hunk, "next"), { desc = "Next hunk" })
      vim.keymap.set({ "n", "x" }, "[h", in_diff_buf(minidiff.goto_hunk, "prev"), { desc = "Prev hunk" })
      -- gH is mini's reset operator; ih widens a cursor-line reset to the whole hunk.
      vim.keymap.set("n", "<leader>gr", "gHih", { remap = true, desc = "Reset hunk" })
      vim.keymap.set("x", "<leader>gr", "gH", { remap = true, desc = "Reset selected lines" })
      vim.keymap.set("n", "<leader>go", in_diff_buf(minidiff.toggle_overlay, 0), { desc = "Toggle diff overlay" })
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    keys = {
      { "<leader>gb", "<cmd>BlameToggle window<cr>", desc = "Git Blame (Window)" },
    },
    config = function()
      local p = require("rose-pine.palette")

      require("blame").setup({
        date_format = "%Y-%m-%d %H:%M",
        views = {
          window = {
            width = 50,
            height = 20,
          },
        },
        merge_consecutive = false,
        max_summary_width = 30,
        colors = { p.love, p.gold, p.rose, p.pine, p.foam, p.iris },
      })
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    -- Conflict detection hooks BufRead, so VeryLazy would miss the file nvim was started with.
    event = "BufReadPre",
    opts = {},
  },
}
