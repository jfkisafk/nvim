return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  config = function()
    require("rose-pine").setup({
      palette = {
        main = { rose = "#ea9a97", pine = "#3e8fb0" },
        dawn = { rose = "#ea9a97", pine = "#3e8fb0" },
      },
      styles = {
        transparency = true,
      },
      highlight_groups = {
        CurSearch = { fg = "base", bg = "leaf", inherit = false },
        Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
        TelescopeBorder = { fg = "highlight_high", bg = "none" },
        TelescopeNormal = { bg = "none" },
        TelescopePromptNormal = { bg = "base" },
        TelescopeResultsNormal = { fg = "subtle", bg = "none" },
        TelescopeSelection = { fg = "text", bg = "base" },
        TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
        ClaudeCodeInlineDiffAdd = { fg = "text", bg = "pine", blend = 20, inherit = false },
        ClaudeCodeInlineDiffDelete = { fg = "text", bg = "love", blend = 20, strikethrough = true, inherit = false },
        ClaudeCodeInlineDiffAddSign = { fg = "pine" },
        ClaudeCodeInlineDiffDeleteSign = { fg = "love" },
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
