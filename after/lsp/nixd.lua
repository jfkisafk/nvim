local nixd = {
  formatting = {
    command = { "nixfmt" },
  },
}

-- darwin-rebuild's default flake; each machine links it to its checkout. Without it nixd uses <nixpkgs>.
local dir = "/etc/nix-darwin"
if vim.fn.filereadable(dir .. "/flake.nix") == 0 then
  return { settings = { nixd = nixd } }
end

-- Option completion is evaluated from the nix-darwin flake, so it tracks the pinned inputs.
-- getFlake rejects paths through a symlink.
local flake = ('(builtins.getFlake "%s")'):format(vim.fn.resolve(dir))
-- Hosts share the same modules, so any configuration yields the same option schema.
local darwin = ("(builtins.head (builtins.attrValues %s.darwinConfigurations))"):format(flake)

nixd.nixpkgs = {
  expr = ("import %s.inputs.nixpkgs { }"):format(flake),
}
nixd.options = {
  nix_darwin = {
    expr = darwin .. ".options",
  },
  home_manager = {
    expr = darwin .. ".options.home-manager.users.type.getSubOptions []",
  },
}

return { settings = { nixd = nixd } }