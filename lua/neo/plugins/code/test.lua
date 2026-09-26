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
        require("neotest-jest")({ jestCommand = "yarn jest" }),
        require("neotest-vstest")({ dap_settings = { type = "coreclr", justMyCode = true } }),
        require("neotest-python")({ runner = "pytest", dap = { justMyCode = false } }),
      },
    })
  end,
  keys = {
    { "<leader>tt", "<cmd>lua require'neotest'.run.run()<cr>",                       desc = "Test Nearest" },
    { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",   desc = "Test File" },
    { "<leader>td", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<cr>", desc = "Debug Test" },
    { "<leader>ts", "<cmd>lua require('neotest').run.stop()<cr>",                    desc = "Test Stop" },
    { "<leader>to", "<cmd>Neotest output<cr>",                                       desc = "Test Output" },
    { "<leader>ty", "<cmd>Neotest summary<cr>",                                      desc = "Test Summary" },
  },
}
