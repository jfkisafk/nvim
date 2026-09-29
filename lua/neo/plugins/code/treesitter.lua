return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = { "LiadOz/nvim-dap-repl-highlights" },
    event = { "BufReadPost", "FileType" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("myconfig.treesitter", { clear = true }),
        pattern = { "*" },
        callback = function(event)
          local filetype = event.match
          local lang = vim.treesitter.language.get_lang(filetype)
          if not lang then
            return
          end

          local is_installed, _ = vim.treesitter.language.add(lang)

          if not is_installed then
            local available_langs = require("nvim-treesitter").get_available()
            if vim.tbl_contains(available_langs, lang) then
              vim.notify("Parser available for " .. lang .. ". Please add to install func", vim.log.levels.INFO)
            end
            return
          end

          if not pcall(vim.treesitter.start, event.buf) then
            return
          end
        end,
      })
    end,

    config = function()
      require("nvim-dap-repl-highlights").setup()
      local ts = require("nvim-treesitter")
      ts.setup({})
      ts.install({
        "astro",
        "awk",
        "bash",
        "c_sharp",
        "comment",
        "css",
        "dap_repl",
        "csv",
        "diff",
        "dockerfile",
        "editorconfig",
        "embedded_template",
        "fish",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "goctl",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "graphql",
        "groovy",
        "haskell",
        "hcl",
        "helm",
        "hjson",
        "html",
        "http",
        "ini",
        "java",
        "javascript",
        "jinja",
        "jinja_inline",
        "jq",
        "json",
        "json5",
        "kotlin",
        "latex",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "nix",
        "passwd",
        "pem",
        "printf",
        "prisma",
        "proto",
        "python",
        "query",
        "regex",
        "requirements",
        "rust",
        "scala",
        "scss",
        "smithy",
        "sql",
        "ssh_config",
        "svelte",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "vue",
        "xml",
        "yaml",
        "zsh",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      multiline_threshold = 2,
    },
    keys = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        silent = true,
        desc = "Go up a context",
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "markdown", "javascript", "javascriptreact", "typescriptreact", "vue", "svelte", "astro" },
    opts = {},
  },
}
