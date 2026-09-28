return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      hover = {
        silent = true,
      },
      documentation = {
        opts = {
          size = {
            max_height = 15,
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "DiagnosticSignInfo",
            },
          },
        },
      },
      -- blink.cmp owns signature help
      signature = {
        enabled = false,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      lsp_doc_border = true, -- add a border to hover docs
    },
  },
}
