-- Biome only for projects that configure it; prettier everywhere else.
local function web(tailwind)
  return function(bufnr)
    local conform = require("conform")
    local chain = { conform.get_formatter_info("biome", bufnr).available and "biome" or "prettier" }
    if tailwind then
      table.insert(chain, "rustywind")
    end
    return chain
  end
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  -- The toggle must exist before the first BufWritePre loads conform.
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle
          .new({
            id = "autoformat",
            name = "Autoformat",
            get = function()
              return not vim.g.disable_autoformat
            end,
            set = function(state)
              vim.g.disable_autoformat = not state
            end,
          })
          :map("<leader>uf")
      end,
    })
  end,
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      cs = { "csharpier" },
      go = { "gofumpt", "goimports-reviser", "golines" },
      java = { "google-java-format" },
      kotlin = { "ktlint" },
      lua = { "stylua" },
      markdown = { "prettier", "markdownlint" },

      javascript = web(true),
      javascriptreact = web(true),
      typescript = web(true),
      typescriptreact = web(true),
      html = web(true),
      vue = web(true),
      svelte = web(true),
      astro = web(false),
      css = web(false),
      scss = { "prettier" },
      less = { "prettier" },
      json = web(false),
      jsonc = web(false),
      graphql = web(false),

      -- "prefer" keeps LSP formatting for filetypes that have no conform formatter.
      ["_"] = { "trim_whitespace", "trim_newlines", lsp_format = "prefer" },
    },
    formatters = {
      biome = { require_cwd = true },
      -- conform's definition targets csharpier 1.x (`format` subcommand); the installed tool is 0.x.
      csharpier = {
        command = vim.fn.expand("~/.dotnet/tools/csharpier"),
        args = { "--write-stdout" },
      },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 3000, lsp_format = "fallback" }
    end,
  },
}
