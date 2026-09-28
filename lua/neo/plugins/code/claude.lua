local HERDR_AGENT_NAME = "claude-" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "-" .. vim.fn.getpid()
local HERDR_SOCKET_PATH = vim.env.HERDR_SOCKET_PATH
local HERDR_WORKSPACE_ID = vim.env.HERDR_WORKSPACE_ID
local NVIM_PANE_ID = vim.env.HERDR_PANE_ID

-- A GUI nvim started from a herdr shell inherits HERDR_* without living in that pane.
local function in_herdr_pane()
  local ui = vim.api.nvim_list_uis()[1]
  local client = ui and vim.api.nvim_get_chan_info(ui.chan).client
  return HERDR_SOCKET_PATH and client and client.name == "nvim-tui"
end

-- The CLI can't focus a pane by ID, so use the socket: one JSON line per connection. nil means no answer.
local function herdr_call(method, params, on_response)
  on_response = vim.schedule_wrap(on_response or function() end)
  if not in_herdr_pane() then
    return on_response(nil)
  end
  local pipe = assert(vim.uv.new_pipe())
  local timeout = assert(vim.uv.new_timer())
  local buffered = ""
  local function finish(response)
    if pipe:is_closing() then
      return
    end
    pipe:close()
    timeout:close()
    on_response(response)
  end
  timeout:start(1000, 0, function()
    finish(nil)
  end)
  pipe:connect(HERDR_SOCKET_PATH, function(connect_err)
    if connect_err then
      return finish(nil)
    end
    pipe:write(vim.json.encode({ id = method, method = method, params = params }) .. "\n")
    pipe:read_start(function(read_err, chunk)
      buffered = buffered .. (chunk or "")
      local line = buffered:match("^([^\n]*)\n")
      if line or read_err or not chunk then
        local ok, response = pcall(vim.json.decode, line or "")
        finish(ok and response or nil)
      end
    end)
  end)
end

local function workspace_claudes(on_claudes)
  herdr_call("agent.list", vim.empty_dict(), function(response)
    local claudes = {}
    for _, agent in ipairs(response and response.result and response.result.agents or {}) do
      if agent.agent == "claude" and agent.workspace_id == HERDR_WORKSPACE_ID then
        table.insert(claudes, agent)
      end
    end
    on_claudes(claudes)
  end)
end

-- Focused Claude when the last diff opened: the best guess for a /ide-attached Claude, which has no name.
local diff_claude_pane_id = nil

-- Prefer the Claude this nvim started, then the one that opened the last diff, then the most recently active.
local function pick_claude(claudes)
  local from_diff, latest = nil, nil
  for _, agent in ipairs(claudes) do
    if agent.name == HERDR_AGENT_NAME then
      return agent
    end
    if agent.pane_id == diff_claude_pane_id then
      from_diff = agent
    end
    if not latest or (agent.state_change_seq or 0) > (latest.state_change_seq or 0) then
      latest = agent
    end
  end
  return from_diff or latest
end

local function claude_pane(on_pane)
  workspace_claudes(function(claudes)
    local agent = pick_claude(claudes)
    on_pane(agent and agent.pane_id)
  end)
end

-- Runs as a diff opens, so also record which Claude sent it.
local function neovim_pane(on_pane)
  workspace_claudes(function(claudes)
    for _, agent in ipairs(claudes) do
      if agent.focused then
        diff_claude_pane_id = agent.pane_id
      end
    end
    on_pane(NVIM_PANE_ID)
  end)
end

-- A replaced diff fires DiffClosed then DiffOpened in one tick; only the latest request may move focus.
local focus_generation = 0
local function focus(resolve_pane)
  focus_generation = focus_generation + 1
  local generation = focus_generation
  resolve_pane(function(pane_id)
    if pane_id and generation == focus_generation then
      herdr_call("pane.focus", { pane_id = pane_id })
    end
  end)
end

-- Show the proposed buffer alone with mini.diff's overlay. Closing the original window doesn't reject
-- the diff (claudecode only rejects once the proposed buffer has no window), and cleanup closes the tab.
local function show_diff_overlay(diff)
  local proposed = vim.api.nvim_win_get_buf(diff.diff_window)
  local original = {}
  if not diff.is_new_file then
    original = vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(diff.target_window), 0, -1, false)
  end

  -- git can't attach to this non-file buffer, and set_ref_text needs it enabled.
  local minidiff = require("mini.diff")
  vim.b[proposed].minidiff_config = { source = minidiff.gen_source.none() }
  minidiff.disable(proposed)
  minidiff.enable(proposed)
  minidiff.set_ref_text(proposed, original)
  if not minidiff.get_buf_data(proposed).overlay then
    minidiff.toggle_overlay(proposed)
  end

  -- Anything above can throw; only drop the side-by-side view once the overlay is up.
  vim.api.nvim_win_close(diff.target_window, true)
  vim.api.nvim_set_current_win(diff.diff_window)
  vim.cmd("diffoff")
  vim.wo[diff.diff_window].winbar = "%= <F1> Accept | <F2> Reject | ]h/[h Next/Prev hunk %="
  vim.wo[diff.diff_window].winhighlight = "WinBar:DiagnosticHint,WinBarNC:DiagnosticHint"
end

return {
  "coder/claudecode.nvim",
  event = "VeryLazy",
  specs = {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          actions = {
            claude_send = function(picker)
              for _, item in ipairs(picker:selected({ fallback = true })) do
                if item.file then
                  require("claudecode").send_at_mention(Snacks.picker.util.path(item), nil, nil, "claude_send")
                end
              end
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-c>"] = { "claude_send", mode = { "n", "i" } },
              },
            },
          },
        },
      })
    end,
  },
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
        vim.fn.getcwd(),
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
        -- "unified" interleaves old lines into the proposed buffer; show_diff_overlay needs it pure.
        layout = "vertical",
        open_in_new_tab = true,
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = { "ClaudeCodeSendComplete", "ClaudeCodeDiffClosed" },
      callback = function()
        focus(claude_pane)
      end,
    })

    -- claudecode swallows errors from this autocmd, so report them; the side-by-side diff stays usable.
    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffOpened",
      callback = function(ev)
        local ok, err = pcall(show_diff_overlay, ev.data)
        if not ok then
          vim.notify("Claude diff overlay failed: " .. tostring(err), vim.log.levels.ERROR)
        end
        focus(neovim_pane)
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
    {
      "<leader>ac",
      function()
        workspace_claudes(function(claudes)
          local agent = pick_claude(claudes)
          if agent then
            herdr_call("pane.focus", { pane_id = agent.pane_id })
          else
            vim.cmd("ClaudeCode")
          end
        end)
      end,
      desc = "Claude: focus or start",
    },
    { "<leader>ap", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude: add buffer to context" },
    { "<leader>ab", "<cmd>ClaudeCodeAddAllBuffers<cr>", desc = "Claude: add all open buffers" },
    { "<leader>aq", "<cmd>ClaudeCodeAddAllQuickfix<cr>", desc = "Claude: add all quickfix items" },
    { "<leader>av", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: send selection" },
    { "<F1>", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: accept diff" },
    { "<F2>", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude: reject diff" },
  },
}
