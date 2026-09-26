return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        documentation = {
          view = "hover",
          opts = { -- lsp_docs settings
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            position = { row = 2, col = 2 },
            size = {
              max_height = 15,
            },
            border = {
              style = "rounded",
            },
            win_options = {
              concealcursor = "n",
              conceallevel = 3,
              winhighlight = {
                Normal = "CmpPmenu",
                FloatBorder = "DiagnosticSignInfo",
              },
            },
          },
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,            -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    })

    local p = require("rose-pine.palette")
    require("notify").setup({
      background_colour = p.base,
      render = "minimal",
      fps = 240,
    })
  end,
}
