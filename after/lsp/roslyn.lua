local dotnet10_root = vim.fn.trim(vim.fn.system("mise where dotnet@10 2>/dev/null"))
local dotnet_bin = (
  dotnet10_root ~= "" and dotnet10_root or vim.fn.trim(vim.fn.system("mise where dotnet 2>/dev/null"))
) .. "/dotnet"
local roslyn_dll = vim.fn.stdpath("data") .. "/mason/packages/roslyn/libexec/Microsoft.CodeAnalysis.LanguageServer.dll"

local capabilities = require("blink.cmp").get_lsp_capabilities()
capabilities.textDocument.diagnostic = nil

return {
  cmd = { dotnet_bin, roslyn_dll, "--stdio" },
  capabilities = capabilities,
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
}
