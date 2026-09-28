-- Match the project's package manager; yarn stays the default when no lockfile is found.
local function jest_command(path)
  local root = vim.fs.root(path, { "yarn.lock", "pnpm-lock.yaml", "package-lock.json" })
  if root and vim.uv.fs_stat(root .. "/pnpm-lock.yaml") then
    return "pnpm jest"
  end
  if root and vim.uv.fs_stat(root .. "/package-lock.json") and not vim.uv.fs_stat(root .. "/yarn.lock") then
    return "npx jest"
  end
  return "yarn jest"
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
    "nsidorenco/neotest-vstest",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest")({ jestCommand = jest_command }),
        require("neotest-vstest")({ dap_settings = { type = "coreclr", justMyCode = true } }),
        require("neotest-python")({ runner = "pytest", dap = { justMyCode = false } }),
      },
    })
  end,
  keys = {
    { "<leader>tt", "<cmd>lua require'neotest'.run.run()<cr>", desc = "Test Nearest" },
    { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Test File" },
    { "<leader>td", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<cr>", desc = "Debug Test" },
    { "<leader>ts", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Test Stop" },
    { "<leader>ty", "<cmd>Neotest summary<cr>", desc = "Test Summary" },
    { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Test Last" },
    { "<leader>tw", "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>", desc = "Test Watch File" },
    { "]T", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", desc = "Next failed test" },
    { "[T", "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", desc = "Previous failed test" },
  },
}
