return {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  opts = {
    popupWin = {
      title = " 󰀘 ",
      hideSearchReplaceLabels = true,
      hideKeymapHints = true,
    },
    notification = {
      icon = " ",
    },
    editingBehavior = { autoCaptureGroups = true },
  },
  keys = {
    {
      "<leader>sr",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = "Search & replace",
    },
  },
}
