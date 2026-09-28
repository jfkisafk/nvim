return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          registries = {
            "github:mason-org/mason-registry",
            "github:Crashdummyy/mason-registry",
          },
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "astro",
        "bashls",
        "cssls",
        "docker_compose_language_service",
        "dockerls",
        "gopls",
        "gradle_ls",
        "graphql",
        "html",
        "jdtls",
        "jsonls",
        "kotlin_language_server",
        "lemminx",
        "lua_ls",
        "marksman",
        "basedpyright",
        "ruff",
        "rust_analyzer",
        "sqlls",
        "svelte",
        "terraformls",
        "vtsls",
        "yamlls",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      -- Update from the lualine outdated count instead of on every startup.
      auto_update = false,
      ensure_installed = {
        "biome",
        "gofumpt",
        "goimports-reviser",
        "golines",
        "google-java-format",
        "ktlint",
        "markdownlint",
        "prettier",
        "rustywind",
        "stylua",

        "gitlint",
        "hadolint",
        "revive",
        "staticcheck",
        "stylelint",
        "tfsec",
        "yamllint",
        "roslyn",
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
  },
}
