return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.checkstyle.with({
          extra_args = { "-c", "/google_checks.xml" },
        }),
        null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.ktlint,
        null_ls.builtins.diagnostics.revive,
        null_ls.builtins.diagnostics.staticcheck,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.diagnostics.tfsec,
        null_ls.builtins.diagnostics.yamllint,
      },
    })
  end,
}
