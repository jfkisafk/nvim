# $HOME/.config dotfiles

> [!IMPORTANT]
> This package uses [stow](https://www.gnu.org/software/stow/) to manage the Neovim configuration in ~/.config.

## Why?

Neovim configuration that is managed stand-alone and not in the other [Nix configuration](https://github.com/jfkisafk/nix).
Even though _nixvim_ is present, adding to Nix meant every small update required reloading
the entire Nix/home-manager configuration.

This way we can lazy load the plugins and LSPs quickly while maintaining the same Neovim
development environment.

Everything else under ~/.config (Karabiner, Herdr, Posting, …) is managed by the Nix configuration.

## Requirements

Make sure you have `stow` installed.

```shell
brew install stow
```

## Installation

Checkout the repository in your preferred dotfiles directory.

```shell
gh repo clone jfkisafk/dotfiles ~/.config/dotfiles
```

Just call stow from the repository root.

```shell
stow .
```