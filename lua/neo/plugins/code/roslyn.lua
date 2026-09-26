return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    config = function()
      -- Disable roslyn's built-in diagnosticProvider (use vim.diagnostic instead)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "roslyn" then
            client.server_capabilities.diagnosticProvider = nil
          end
        end,
      })

      require("roslyn").setup()
    end,
  },
}
