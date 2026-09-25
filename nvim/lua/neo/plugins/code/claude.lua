local cwd = vim.fn.getcwd()
local HERDR_AGENT_NAME = "claude-" .. vim.fn.fnamemodify(cwd, ":t") .. "-" .. vim.fn.getpid()
local claude_pane_id = nil

local function focus_claude_pane()
  vim.fn.jobstart({ "herdr", "agent", "focus", HERDR_AGENT_NAME }, { detach = true })
end

local function focus_neovim_pane()
  if not claude_pane_id then
    return
  end
  vim.fn.jobstart({ "herdr", "pane", "focus", "--pane", claude_pane_id, "--direction", "left" }, { detach = true })
end

return {
  "coder/claudecode.nvim",
  event = "VeryLazy",
  config = function()
    local claudecode = require("claudecode")

    local function open_claude_in_herdr_pane(cmd, env)
      local extra_args = vim.split(cmd, "%s+", { trimempty = true })
      table.remove(extra_args, 1)

      local split_cmd = {
        "herdr",
        "pane",
        "split",
        "--current",
        "--direction",
        "right",
        "--cwd",
        cwd,
        "--focus",
      }
      for key, value in pairs(env) do
        table.insert(split_cmd, "--env")
        table.insert(split_cmd, key .. "=" .. value)
      end

      local ok, pane_id = pcall(function()
        return vim.json.decode(vim.fn.system(split_cmd)).result.pane.pane_id
      end)
      if not (ok and pane_id) then
        vim.notify("herdr: failed to split a pane for Claude Code", vim.log.levels.ERROR)
        return { "true" }
      end
      claude_pane_id = pane_id

      local start_cmd = { "herdr", "agent", "start", HERDR_AGENT_NAME, "--kind", "claude", "--pane", pane_id }
      if #extra_args > 0 then
        table.insert(start_cmd, "--")
        vim.list_extend(start_cmd, extra_args)
      end
      return start_cmd
    end

    claudecode.setup({
      terminal = {
        provider = "external",
        provider_opts = {
          external_terminal_cmd = open_claude_in_herdr_pane,
        },
      },
      diff_opts = {
        layout = "unified",
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = { "ClaudeCodeSendComplete", "ClaudeCodeDiffClosed" },
      callback = focus_claude_pane,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffOpened",
      callback = function(ev)
        local diff_window = ev.data and ev.data.diff_window
        if diff_window and vim.api.nvim_win_is_valid(diff_window) then
          vim.api.nvim_set_current_win(diff_window)
        end
        focus_neovim_pane()
      end,
    })

    vim.api.nvim_create_user_command("ClaudeCodeAddAllBuffers", function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
          local path = vim.api.nvim_buf_get_name(buf)
          if path ~= "" then
            claudecode.send_at_mention(path, nil, nil, "add_all_buffers")
          end
        end
      end
    end, {})

    vim.api.nvim_create_user_command("ClaudeCodeAddAllQuickfix", function()
      local seen = {}
      for _, item in ipairs(vim.fn.getqflist()) do
        local path = item.bufnr > 0 and vim.api.nvim_buf_get_name(item.bufnr) or ""
        if path ~= "" and not seen[path] then
          seen[path] = true
          claudecode.send_at_mention(path, nil, nil, "add_all_quickfix")
        end
      end
    end, {})
  end,
  keys = {
    { "<leader>cp", "<cmd>ClaudeCodeAdd %<cr>",          desc = "Claude: add buffer to context" },
    { "<leader>cb", "<cmd>ClaudeCodeAddAllBuffers<cr>",  desc = "Claude: add all open buffers" },
    { "<leader>cq", "<cmd>ClaudeCodeAddAllQuickfix<cr>", desc = "Claude: add all quickfix items" },
    { "<leader>cv", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: send selection" },
    { "<F1>", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: accept diff" },
    { "<F2>", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Claude: reject diff" },
  },
}
