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
        { text = "󰀘 ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "DiagnosticSignWarn" }
      )
      vim.fn.sign_define(
        "DapConditionalBreakpoint",
        { text = "󰀘 ", texthl = "DiagnosticSignHint", linehl = "", numhl = "DiagnosticSignHint" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "󰀘 ", texthl = "DiagnosticSignInfo", linehl = "", numhl = "DiagnosticSignInfo" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = " ", texthl = "DiagnosticSignHint", linehl = "Visual", numhl = "DiagnosticSignHint" }
      )

      dap.adapters.coreclr = {
        type = "executable",
        command = "/run/current-system/sw/bin/netcoredbg",
        args = { "--interpreter=vscode" },
      }

      local function find_app_port()
        local dir = vim.fs.root(0, function(name)
          return name:match("%.csproj$") ~= nil
        end)
        if not dir then
          return nil
        end
        local settings_path = dir .. "/Properties/launchSettings.json"
        if vim.fn.filereadable(settings_path) == 0 then
          return nil
        end
        local content = table.concat(vim.fn.readfile(settings_path), "\n")
        local port = content:match('"applicationUrl"%s*:%s*"[^"]*://[^:]*:(%d+)')
        return port and tonumber(port)
      end

      local function smart_pick_process()
        local port = find_app_port()
        if not port then
          return require("dap.utils").pick_process({ filter = "dotnet" })
        end

        -- LISTEN only: clients connected to the port (e.g. a browser tab) would otherwise match too.
        local output = vim.fn.system({ "lsof", "-ti", "tcp:" .. port, "-sTCP:LISTEN" })
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
      { "<F6>", "<cmd>lua require'dap'.continue()<CR>", desc = "DAP continue" },
      { "<F8>", "<cmd>lua require'dap'.step_over()<CR>", desc = "DAP step over" },
      { "<F7>", "<cmd>lua require'dap'.step_into()<CR>", desc = "DAP step into" },
      { "<F9>", "<cmd>lua require'dap'.step_out()<CR>", desc = "DAP step out" },
      { "<F5>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "DAP toggle breakpoint" },
      { "<F10>", "<cmd>lua require'dap'.terminate()<CR>", desc = "DAP terminate" },
    },
  },
  {
    "igorlfs/nvim-dap-view",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
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
      { "<leader>du", "<cmd>DapViewToggle<cr>", desc = "DAP View toggle" },
      { "<leader>dw", "<cmd>DapViewWatch<cr>", desc = "DAP View add watch" },
      { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "DAP hover" },
    },
  },
}
