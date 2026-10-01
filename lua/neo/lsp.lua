local keymap = vim.keymap -- for conciseness

-- Jump among the most severe diagnostics first, so warnings don't hide errors; info/hint are skipped.
local function jump_by_severity(count)
  local top
  for _, d in ipairs(vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.WARN } })) do
    if not top or d.severity < top then
      top = d.severity
    end
  end
  if not top then
    return
  end
  vim.diagnostic.jump({ count = count, severity = top, float = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }

    -- set keybinds
    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", function()
      require("tiny-code-action").code_action()
    end, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", function()
      jump_by_severity(-1)
    end, opts) -- jump to previous diagnostic in buffer
    --
    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]d", function()
      jump_by_severity(1)
    end, opts) -- jump to next diagnostic in buffer

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
  end,
})

vim.lsp.enable("nixd")
vim.lsp.inlay_hint.enable(true)

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,
  float = { source = true },
  -- Info/hint stay reachable through <leader>qd; showing them inline is too noisy (e.g. Roslyn IDE0305).
  underline = { severity = { min = severity.WARN } },
  signs = {
    severity = { min = severity.WARN },
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})
