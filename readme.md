# nvim

My Neovim configuration, managed stand-alone and not in the [Nix configuration](https://github.com/jfkisafk/nix).
Even though _nixvim_ is present, adding to Nix meant every small update required reloading
the entire Nix/home-manager configuration.

This way we can lazy load the plugins and LSPs quickly while maintaining the same Neovim
development environment.

## Installation

Clone the repository straight into the Neovim config directory.

```shell
gh repo clone jfkisafk/nvim ~/.config/nvim
```

Or clone it anywhere and let home-manager link it, so it stays editable without a rebuild:

```nix
xdg.configFile."nvim".source =
  config.lib.file.mkOutOfStoreSymlink "/Volumes/nitro/nvim";
```

Plugins and LSPs install on the first launch of `nvim`.