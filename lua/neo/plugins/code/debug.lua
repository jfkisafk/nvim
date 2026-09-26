return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "mfussenegger/nvim-dap-python" },
    config = function()
      local dap = require("dap")

      require("dap-python").setup(vim.fn.expand("~/.virtualenvs/debugpy/bin/python"))

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "󰀘 ", texthl = "DiagnosticSignError", linehl = "", numhl = "DiagnosticSignError" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "󰀘 ", texthl = "DiagnosticSignError", linehl = "", numhl = "DiagnosticSignError" }
      )
      vim.fn.sign_define(
        "DapConditionalBreakpoint",
        { text = "󰀘 ", texthl = "DiagnosticSignHint", linehl = "", numhl = "DiagnosticSignHint" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = " ", texthl = "DiagnosticSignHint", linehl = "", numhl = "DiagnosticSignHint" }
      )

      dap.adapters.coreclr = {
        type = "executable",
        command = "/run/current-system/sw/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      local function find_csproj()
        local dir = vim.fn.expand("%:p:h")
        while dir and dir ~= "/" do
          local csproj = vim.fn.glob(dir .. "/*.csproj")
          if csproj ~= "" then
            return csproj:gmatch("[^\n]+")()
          end
          dir = vim.fn.fnamemodify(dir, ":h")
        end
        return nil
      end

      local function find_app_port()
        local csproj = find_csproj()
        if not csproj then
          return 5000
        end
        local dir = vim.fn.fnamemodify(csproj, ":h")
        local settings_path = dir .. "/Properties/launchSettings.json"
        if vim.fn.filereadable(settings_path) == 0 then
          return 5000
        end
        local content = table.concat(vim.fn.readfile(settings_path), "\n")
        local port = content:match('"applicationUrl"%s*:%s*"[^"]*://[^:]*:(%d+)')
        return port and tonumber(port) or 5000
      end

      local function smart_pick_process()
        local port = find_app_port()
        local output = vim.fn.system({ "lsof", "-ti", ":" .. port })
        local pid = output:match("(%d+)")
        if pid then
          return tonumber(pid)
        end

        vim.notify("No process found on port " .. port, vim.log.levels.WARN)
        return dap.ABORT
      end

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "attach - netcoredbg",
          request = "attach",
          processId = smart_pick_process,
          justMyCode = false,
        },
      }
    end,
    keys = {
      { "<F6>", "<cmd>lua require'dap'.continue()<CR>",          desc = "DAP continue" },
      { "<F8>", "<cmd>lua require'dap'.step_over()<CR>",         desc = "DAP step over" },
      { "<F7>", "<cmd>lua require'dap'.step_into()<CR>",         desc = "DAP step into" },
      { "<F9>", "<cmd>lua require'dap'.step_out()<CR>",          desc = "DAP step out" },
      { "<F5>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "DAP toggle breakpoint" },
    },
  },
  {
    "igorlfs/nvim-dap-view",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local p = require("rose-pine.palette")

      -- nvim-dap-view highlight groups
      vim.api.nvim_set_hl(0, "NvimDapViewSeparator", { fg = p.highlight_med })
      vim.api.nvim_set_hl(0, "NvimDapViewBoolean", { fg = p.rose })
      vim.api.nvim_set_hl(0, "NvimDapViewConstant", { fg = p.gold })
      vim.api.nvim_set_hl(0, "NvimDapViewFloat", { fg = p.gold })
      vim.api.nvim_set_hl(0, "NvimDapViewNumber", { fg = p.gold })
      vim.api.nvim_set_hl(0, "NvimDapViewString", { fg = p.foam })
      vim.api.nvim_set_hl(0, "NvimDapViewFunction", { fg = p.iris })
      vim.api.nvim_set_hl(0, "NvimDapViewMissingData", { fg = p.love })
      vim.api.nvim_set_hl(0, "NvimDapViewWatchExpr", { fg = p.rose, bold = true })
      vim.api.nvim_set_hl(0, "NvimDapViewWatchError", { fg = p.love })
      vim.api.nvim_set_hl(0, "NvimDapViewWatchUpdated", { fg = p.gold, bg = p.highlight_low })
      vim.api.nvim_set_hl(0, "NvimDapViewFileName", { fg = p.pine })
      vim.api.nvim_set_hl(0, "NvimDapViewLineNumber", { fg = p.gold })
      vim.api.nvim_set_hl(0, "NvimDapViewFrameCurrent", { fg = p.gold, bg = p.highlight_low })
      vim.api.nvim_set_hl(0, "NvimDapViewThread", { fg = p.iris, bold = true })
      vim.api.nvim_set_hl(0, "NvimDapViewThreadStopped", { fg = p.pine })
      vim.api.nvim_set_hl(0, "NvimDapViewThreadError", { fg = p.love })
      vim.api.nvim_set_hl(0, "NvimDapViewExceptionFilterEnabled", { fg = p.foam })
      vim.api.nvim_set_hl(0, "NvimDapViewExceptionFilterDisabled", { fg = p.love })
      vim.api.nvim_set_hl(0, "NvimDapViewTab", { fg = p.subtle })
      vim.api.nvim_set_hl(0, "NvimDapViewTabSelected", { fg = p.foam })
      vim.api.nvim_set_hl(0, "NvimDapViewTabFill", { bg = p.base })
      vim.api.nvim_set_hl(0, "NvimDapViewControlNC", { fg = p.muted })
      vim.api.nvim_set_hl(0, "NvimDapViewControlPlay", { fg = p.foam })
      vim.api.nvim_set_hl(0, "NvimDapViewControlPause", { fg = p.rose })
      vim.api.nvim_set_hl(0, "NvimDapViewControlRunLast", { fg = p.iris })
      vim.api.nvim_set_hl(0, "NvimDapViewControlStepInto", { fg = p.iris })
      vim.api.nvim_set_hl(0, "NvimDapViewControlStepOver", { fg = p.iris })
      vim.api.nvim_set_hl(0, "NvimDapViewControlStepOut", { fg = p.iris })
      vim.api.nvim_set_hl(0, "NvimDapViewControlStepBack", { fg = p.iris })
      vim.api.nvim_set_hl(0, "NvimDapViewControlTerminate", { fg = p.love })
      vim.api.nvim_set_hl(0, "NvimDapViewControlDisconnect", { fg = p.love })

      require("dap-view").setup({
        winbar = {
          sections = { "scopes", "watches", "threads", "exceptions", "repl" },
          default_section = "scopes",
          show_keymap_hints = false,
          controls = {
            enabled = true,
          },
          base_sections = {
            threads = { label = "" },
            exceptions = { label = "󰈸" },
            breakpoints = { label = "󰀘 " },
            watches = { label = " " },
            scopes = { label = " " },
            repl = { label = " " },
          },
        },
        windows = {
          size = 0.3,
          position = "right",
        },
        follow_tab = true,
        auto_toggle = true,
      })
    end,
    keys = {
      { "<leader>du", "<cmd>DapViewToggle<cr>",                         desc = "DAP View toggle" },
      { "<leader>dw", "<cmd>DapViewWatch<cr>",                          desc = "DAP View add watch" },
      { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "DAP hover" },
    },
  },
}
