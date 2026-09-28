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
        NvimDapViewSeparator = { fg = "highlight_med" },
        NvimDapViewBoolean = { fg = "rose" },
        NvimDapViewConstant = { fg = "gold" },
        NvimDapViewFloat = { fg = "gold" },
        NvimDapViewNumber = { fg = "gold" },
        NvimDapViewString = { fg = "foam" },
        NvimDapViewFunction = { fg = "iris" },
        NvimDapViewMissingData = { fg = "love" },
        NvimDapViewWatchExpr = { fg = "rose", bold = true },
        NvimDapViewWatchError = { fg = "love" },
        NvimDapViewWatchUpdated = { fg = "gold", bg = "highlight_low" },
        NvimDapViewFileName = { fg = "pine" },
        NvimDapViewLineNumber = { fg = "gold" },
        NvimDapViewFrameCurrent = { fg = "gold", bg = "highlight_low" },
        NvimDapViewThread = { fg = "iris", bold = true },
        NvimDapViewThreadStopped = { fg = "pine" },
        NvimDapViewThreadError = { fg = "love" },
        NvimDapViewExceptionFilterEnabled = { fg = "foam" },
        NvimDapViewExceptionFilterDisabled = { fg = "love" },
        NvimDapViewTab = { fg = "subtle" },
        NvimDapViewTabSelected = { fg = "foam" },
        NvimDapViewTabFill = { bg = "base" },
        NvimDapViewControlNC = { fg = "muted" },
        NvimDapViewControlPlay = { fg = "foam" },
        NvimDapViewControlPause = { fg = "rose" },
        NvimDapViewControlRunLast = { fg = "iris" },
        NvimDapViewControlStepInto = { fg = "iris" },
        NvimDapViewControlStepOver = { fg = "iris" },
        NvimDapViewControlStepOut = { fg = "iris" },
        NvimDapViewControlStepBack = { fg = "iris" },
        NvimDapViewControlTerminate = { fg = "love" },
        NvimDapViewControlDisconnect = { fg = "love" },
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
