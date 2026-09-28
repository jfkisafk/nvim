-- mason's roslyn-language-server needs .NET 10; the system install is 9.x.
local dotnet_root = vim.fn.trim(vim.fn.system("mise where dotnet@10 2>/dev/null"))
if dotnet_root == "" then
  dotnet_root = vim.fn.trim(vim.fn.system("mise where dotnet 2>/dev/null"))
end

return {
  cmd_env = dotnet_root ~= "" and { DOTNET_ROOT = dotnet_root } or nil,
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
  },
}