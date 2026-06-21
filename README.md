# dotfiles

My personal config files. Linux-primary, with some macOS support.

## Install

```sh
git clone git@github.com:joelhans/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
```

The install script symlinks everything into place, installs [antidote](https://github.com/mattmc3/antidote) and [Starship](https://starship.rs/) if missing, and handles a few Linux-only extras (xremap, KDE keyboard settings, icon theme).

Run `./check` first to see what's installed and what's missing, with hints for installing anything that's not.

## What's here

| File/dir | What it is |
|---|---|
| `ghostty` | [Ghostty](https://ghostty.org/) terminal config — Catppuccin Mocha, custom keybindings |
| `init.lua` | Neovim config |
| `zellij` | [Zellij](https://zellij.dev/) multiplexer config |
| `lazygit.yml` | Lazygit config (autofetch off) |
| `starship.toml` | Starship prompt |
| `kxkbrc` | KDE keyboard settings |
| `xremap.yaml` | Key remapping via [xremap](https://github.com/xremap/xremap) (Caps Lock → Ctrl/Escape, etc.) |
| `xremap.service` | systemd user service for xremap |
| `.zshrc` / `.zsh_aliases` / `.zsh_exports` | Zsh config, split into three files |
| `.gitconfig` | Git config — SSH commit signing via 1Password |
| `bin/` | Small utility scripts |

## Shell

Zsh with antidote for plugins. Config is split:
- `.zsh_exports` — env vars and `$EDITOR` detection
- `.zsh_aliases` — aliases and short functions
- `.zshrc` — everything else (history, completions, plugin loading, tool init)
