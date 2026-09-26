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

    local node_fts = {
      javascript = true,
      typescript = true,
      javascriptreact = true,
      typescriptreact = true,
      svelte = true,
      astro = true,
      vue = true,
    }

    local function is_obsidian_note()
      return vim.bo.filetype == "markdown" and vim.b.obsidian_buffer == true
    end

    local function obsidian_status()
      if not is_obsidian_note() then
        return ""
      end
      local ws = _G.Obsidian and _G.Obsidian.workspace
      return ws and (" " .. ws.name) or ""
    end

    local function roslyn_status()
      if vim.bo.filetype ~= "cs" then
        return ""
      end
      local clients = vim.lsp.get_clients({ name = "roslyn" })
      if #clients == 0 then
        return ""
      end

      local bufnr = vim.api.nvim_get_current_buf()
      local file_dir = vim.fn.expand("#" .. bufnr .. ":p:h")
      local csproj = vim.fs.find(function(name)
        return name:match("%.csproj$")
      end, { upward = true, path = file_dir })[1]

      if csproj then
        for _, line in ipairs(vim.fn.readfile(csproj)) do
          local match = line:match("<TargetFrameworks?>(.-)</TargetFrameworks?>")
          if match then
            return " " .. match
          end
        end
      end

      local solution = vim.g.roslyn_nvim_selected_solution
      return solution and (" " .. vim.fn.fnamemodify(solution, ":t:r")) or " Roslyn"
    end

    local function node_status()
      if not node_fts[vim.bo.filetype] then
        return ""
      end
      if vim.b.node_version then
        return "󰎙 " .. vim.b.node_version
      end
      local version = vim.fn.system("node --version 2>/dev/null"):gsub("%s+", ""):gsub("^v", "")
      if version ~= "" then
        vim.b.node_version = version
        return "󰎙 " .. version
      end
      return "󰎙 Node"
    end

    mason_check()
    mason_registry:on("package:install:success", vim.schedule_wrap(mason_check))

    require("lualine").setup({
      options = { theme = theme },
      sections = {
        lualine_x = {
          {
            obsidian_status,
            cond = is_obsidian_note,
            color = { fg = p.gold },
          },
          {
            roslyn_status,
            cond = function()
              return vim.bo.filetype == "cs"
            end,
            color = { fg = p.foam },
          },
          {
            node_status,
            cond = function()
              return node_fts[vim.bo.filetype]
            end,
            color = { fg = p.foam },
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
          {
            function()
              return symbols.get():gsub("%b()", "")
            end,
            cond = symbols.has,
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
