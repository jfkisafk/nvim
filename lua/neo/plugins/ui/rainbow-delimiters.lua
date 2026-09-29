return {
  "HiPhish/rainbow-delimiters.nvim",
  submodules = false,
  event = { "BufReadPost", "BufNewFile" },
  main = "rainbow-delimiters.setup",
  opts = {
    -- rose-pine's built-in groups, ordered rose, pine, foam, iris, gold, love
    highlight = {
      "RainbowDelimiterOrange",
      "RainbowDelimiterBlue",
      "RainbowDelimiterCyan",
      "RainbowDelimiterViolet",
      "RainbowDelimiterYellow",
      "RainbowDelimiterRed",
    },
  },
}