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
  },
  keys = {
    {
      "<leader>fs",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = "Rip Substitute",
    },
  },
}
