return {
  "nvim-lualine/lualine.nvim",
  event = "ColorScheme",
  config = function()
    local p = require("rose-pine.palette")
    local lazy_status = require("lazy.status")

    local function mode_theme(color)
      return {
        a = { bg = color, fg = p.base, gui = "bold" },
        b = { fg = color },
        c = { fg = p.text },
      }
    end

    local theme = {
      normal = mode_theme(p.rose),
      insert = mode_theme(p.foam),
      visual = mode_theme(p.iris),
      replace = mode_theme(p.pine),
      command = mode_theme(p.love),
      inactive = {
        a = { bg = p.base, fg = p.muted, gui = "bold" },
        b = { fg = p.muted },
        c = { fg = p.muted },
      },
    }

    local trouble = require("trouble")
    local symbols = trouble.statusline({
      mode = "lsp_document_symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = "{kind_icon}{symbol.name:Normal}",
      -- Set to the lualine section you want to use (fixes background color)
      hl_group = "lualine_c_normal",
    })

    local mason_registry = require("mason-registry")
    local mason_outdated = {}

    local function mason_check()
      mason_outdated = {}
      for _, pkg in ipairs(mason_registry.get_installed_packages()) do
        local installed = pkg:get_installed_version()
        local latest = pkg:get_latest_version()
        if installed and latest and installed ~= latest then
          table.insert(mason_outdated, { name = pkg.name, version = latest })
        end
      end
    end

    mason_check()
    mason_registry:on("package:install:success", vim.schedule_wrap(mason_check))

    local bubble = { left = "", right = "" }

    require("lualine").setup({
      options = {
        theme = theme,
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
            separator = bubble,
          },
          { "branch", icon = "", separator = bubble },
        },
        lualine_b = {
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            source = function()
              local summary = vim.b.minidiff_summary
              return summary and { added = summary.add, modified = summary.change, removed = summary.delete }
            end,
          },
        },
        lualine_c = {
          {
            function()
              return symbols.get():gsub("%b()", "")
            end,
            cond = symbols.has,
          },
        },
        lualine_x = {
          {
            function()
              return "󰑋 " .. vim.fn.reg_recording()
            end,
            cond = function()
              return vim.fn.reg_recording() ~= ""
            end,
            color = { fg = p.love, gui = "italic,bold" },
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = p.love },
          },
          {
            function()
              return "󱌣 " .. #mason_outdated
            end,
            cond = function()
              return #mason_outdated > 0
            end,
            color = { fg = p.iris },
          },
        },
        lualine_y = {
          { "diagnostics", color = { gui = "bold" } },
        },
        lualine_z = {
          { "lsp_status", icon = " ", color = { gui = "italic" }, separator = bubble },
          {
            function()
              return "󰚩 "
            end,
            cond = function()
              return package.loaded.claudecode ~= nil and require("claudecode").is_claude_connected()
            end,
            separator = bubble,
          },
        },
      },
    })
  end,
}
