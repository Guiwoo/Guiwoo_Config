# AGENTS.md - Dotfiles Configuration Repository

This repository contains personal development environment configuration files for macOS.

---

## Repository Overview

A **dotfiles repository** managing configurations for:
- **Terminal**: Ghostty, iTerm2, tmux, zsh
- **Editor**: Neovim (primary), Vim, VSCode
- **Productivity**: Raycast, Karabiner-Elements, Rectangle
- **Shell Tools**: starship prompt, fzf, zoxide, bat, yazi
- **Development**: gh (GitHub CLI), gopass, pet snippets

---

## Project Structure

```
~/.config/
├── nvim/                 # Neovim configuration (Lazy.nvim plugin manager)
│   ├── init.lua          # Entry point - loads vim-custom, vim-keymap, plugins
│   └── lua/
│       ├── vim-custom.lua    # General vim settings (tabs, numbers, etc.)
│       ├── vim-keymap.lua    # Custom keymaps
│       └── plugins/          # Individual plugin configs (lazy.nvim specs)
├── tmux/tmux.conf        # tmux configuration (prefix: Ctrl+O)
├── zsh/                  # Zsh configuration modules
│   ├── eval.zsh          # fnm, starship initialization
│   ├── zshrc.fzf         # fzf configuration and custom functions
│   └── zshrc.zoxide      # zoxide smart cd configuration
├── ghostty/config        # Ghostty terminal emulator settings
├── starship.toml         # Starship prompt configuration (catppuccin_mocha)
├── karabiner/            # macOS key remapping (vim-style navigation)
├── raycast/              # Raycast extensions and config
├── gh/                   # GitHub CLI configuration
├── pet/                  # Pet command snippets
├── vim/.vimrc            # Traditional vim config
└── install.sh            # Bootstrap script for new machines
```

---

## Commands

### Installation (New Machine Setup)
```bash
# Run the install script
./install.sh    # Installs Homebrew packages, fonts, copies configs
```

### Neovim
```bash
nvim                          # Open Neovim
:Lazy                         # Plugin manager UI
:Mason                        # LSP/tool installer UI
:checkhealth                  # Verify setup
:KanagawaCompile              # Recompile theme after changes
```

### tmux
```bash
# Install plugin manager first:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Key bindings (prefix is Ctrl+O):
Ctrl+O, I                     # Install plugins
Ctrl+O, r                     # Reload config
Ctrl+O, c                     # New window
Ctrl+O, x                     # Kill pane
Ctrl+O, v                     # Split vertical
Ctrl+O, h                     # Split horizontal
Alt+,                         # Previous window
Alt+.                         # Next window
```

### Git
```bash
gh pr checkout               # Aliased as 'gh co'
```

---

## Neovim Configuration Details

### Plugin Manager
- **Lazy.nvim** - plugins defined in `nvim/lua/plugins/*.lua`

### Key Leader
- **Space** (`<leader>` = ` `)

### Core Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files (fzf-lua) |
| `<leader>fg` | Live grep |
| `<leader>fc` | Find files in config dir |
| `<leader>fo` | Recent files |
| `<leader>fw` | Grep word under cursor |
| `<leader>fs` | Document symbols |
| `<leader><leader>` | Switch buffers |
| `<leader>ol` | Oil file manager (float) |
| `<leader>gbl` | Toggle git blame |
| `<leader>ce` | Toggle Copilot |
| `gl` | Open diagnostic float |
| `grn` | LSP rename |
| `gra` | Code action |
| `grr` | Find references |
| `grd` | Go to definition |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `Esc` | Clear search highlight / Close Oil |

### LSP Servers Configured
- `gopls` - Go
- `pyright` - Python
- `lua_ls` - Lua
- `bashls` - Bash
- `eslint` - JavaScript/TypeScript

### Editor Settings
- **Tab/Indent**: 2 spaces (expandtab)
- **Line numbers**: Relative
- **Clipboard**: System clipboard (`unnamedplus`)
- **Fold**: Indent-based, open by default (level 99)
- **Search**: Case-insensitive unless uppercase
- **Theme**: Kanagawa (wave, transparent background)

---

## Shell Configuration

### Zsh Structure
Zsh configs are modular in `~/.config/zsh/`:
```bash
# Loaded via ~/.zshrc block:
source ~/.config/zsh/zshrc.*
```

### Key Shell Aliases/Functions
| Command | Action |
|---------|--------|
| `c <dir>` | Smart cd with zoxide |
| `zi` | Interactive zoxide |
| `zz` | Yazi file manager (cd on exit) |
| `fco` | Fuzzy git checkout |
| `fshow` | Git commit browser |
| `ftpane` | Switch tmux pane |

### FZF Configuration
- **Trigger**: `.` (not default `**`)
- **Preview**: bat for files, tree for directories
- **Bindings**: 
  - `Alt+f`: File search
  - `Alt+d`: Directory search
  - `Alt+r`: Vim MRU files

### Node Version Management
- **fnm** (Fast Node Manager) with auto-switching on cd

---

## Terminal Keybindings

### Ghostty (prefix: Ctrl+O)
| Key | Action |
|-----|--------|
| `Ctrl+O, c` | Quick terminal |
| `Ctrl+O, v` | Split right |
| `Ctrl+O, h` | Split down |
| `Ctrl+O, x` | Close pane |
| `Ctrl+O, z` | Toggle zoom |
| `Ctrl+H/J/K/L` | Navigate splits |
| `Cmd+Shift+U/D/L/R` | Resize splits |

### Karabiner (System-wide)
| Key | Action |
|-----|--------|
| `Left Ctrl + Shift + H/J/K/L` | Mouse movement (fast) |
| `Left Alt + Shift + H/J/K/L` | Mouse movement (slow) |
| `Left Option + [` | Home |
| `Left Option + ]` | End |
| `Left Option + H/J/K/L` | Arrow keys (vim-style) |

---

## Raycast Shortcuts
| Shortcut | App |
|----------|-----|
| `Ctrl+Cmd+S` | Slack |
| `Ctrl+Cmd+E` | Editor |
| `Ctrl+Cmd+T` | Terminal |
| `Ctrl+Cmd+P` | ChatGPT |
| `Ctrl+Cmd+C` | Chrome |

---

## Conventions

### File Naming
- Plugin configs: `nvim/lua/plugins/<plugin-name>.lua`
- Zsh modules: `zsh/zshrc.<feature>`
- Backup files: `*.bak` or `*.bak.*`

### Code Style (Lua/Neovim)
- 2-space indentation
- Use `vim.opt` over `vim.cmd("set ...")` when possible
- Plugin configs return single table with lazy.nvim spec
- Keymaps use `desc` for documentation

### Theme/Colors
- **Primary palette**: catppuccin_mocha (starship), kanagawa-wave (nvim)
- **Terminal**: Ghostty with "Ayu Mirage" theme, 95% opacity

---

## Important Patterns

### Adding a New Neovim Plugin
1. Create `nvim/lua/plugins/<name>.lua`
2. Return lazy.nvim spec table
3. Run `:Lazy` to install

### Adding a New Zsh Module
1. Create `zsh/zshrc.<feature>`
2. It auto-loads if following the `zshrc.*` pattern

### Modifying Karabiner
- Edit `karabiner/karabiner.json` directly
- Automatic backups stored in `karabiner/automatic_backups/`

---

## Gotchas

1. **tmux prefix changed**: Ctrl+O (not default Ctrl+B)
2. **FZF trigger changed**: `.` (not default `**`)
3. **Neovim copilot accept**: Right arrow key (not Tab)
4. **zoxide alias**: `c` (not default `z`)
5. **Ghostty keybinds**: Some mirror tmux but are native terminal splits
6. **Config path assumption**: Scripts assume `~/.config/` location
7. **install.sh typo**: Contains `cargro` (should be `cargo`) on line 30

---

## Dependencies (installed via install.sh)

### Homebrew Packages
zsh, vim, neovim, tmux, zoxide, bat, tree-sitter, fzf, ripgrep, yazi, lazygit, ghostty, graphviz, readline, fzf-tab, zstd

### Casks
rectangle

### Fonts
- CaskaydiaCove Nerd Font (primary)
- 3270 Nerd Font
- Nerd Fonts Symbols Only

---

## Related Tools Not in This Repo
- **Homebrew**: Package manager (installed by script if missing)
- **oh-my-zsh**: May be expected but not explicitly configured here
- **fnm**: Node version manager (initialized in eval.zsh)
