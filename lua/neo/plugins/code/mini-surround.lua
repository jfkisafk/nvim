return {
  "nvim-mini/mini.surround",
  version = false,
  event = "VeryLazy",
  config = function()
    -- vim-surround keys; mini's default s-prefix would shadow flash's s.
    require("mini.surround").setup({
      mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
        find = "",
        find_left = "",
        highlight = "",
        update_n_lines = "",
      },
    })

    -- Visual ys would make every visual y wait for timeoutlen; S belongs to flash.
    vim.keymap.del("x", "ys")
    vim.keymap.set("x", "gs", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true, desc = "Surround selection" })
    vim.keymap.set("n", "yss", "ys_", { remap = true, desc = "Surround line" })
  end,
}
