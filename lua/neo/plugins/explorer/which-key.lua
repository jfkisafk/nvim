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
  opts = {
    preset = "helix",
    icons = { mappings = false },
    show_help = false,
    spec = {
      { "<leader><tab>", group = "Tab" },
      { "<leader>a", group = "Claude", mode = { "n", "v" } },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "Lazygit" },
      { "<leader>o", group = "Obsidian" },
      { "<leader>q", group = "Quickfix" },
      { "<leader>r", group = "Rename/Restart" },
      { "<leader>s", group = "Search/Split" },
      { "<leader>t", group = "Test" },
      { "<leader>u", group = "Toggle" },
      { "<leader>w", group = "Session" },
      { "<leader>x", group = "Trouble" },
    },
  },
}