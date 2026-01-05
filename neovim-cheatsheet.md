# NEOVIM CHEATSHEET

Based on your `~/.config/nvim/init.lua` configuration.

**Leader key: `Space`**

---

## Modes

| Key | Mode | Description |
|-----|------|-------------|
| `i` | Insert | Type text (before cursor) |
| `a` | Insert | Type text (after cursor) |
| `A` | Insert | Type at end of line |
| `o` | Insert | New line below |
| `O` | Insert | New line above |
| `v` | Visual | Select characters |
| `V` | Visual Line | Select lines |
| `Ctrl-v` | Visual Block | Select rectangle |
| `Esc` or `jk` | Normal | Back to normal mode |
| `:` | Command | Enter commands |

---

## Basic Movement

| Key | Description |
|-----|-------------|
| `h` | Left |
| `j` | Down |
| `k` | Up |
| `l` | Right |
| `w` | Next word (start) |
| `b` | Previous word (start) |
| `e` | Next word (end) |
| `0` | Start of line |
| `^` | First non-blank character |
| `$` | End of line |
| `gg` | Start of file |
| `G` | End of file |
| `{` | Previous paragraph |
| `}` | Next paragraph |
| `Ctrl-d` | Half page down (centered) |
| `Ctrl-u` | Half page up (centered) |
| `%` | Jump to matching bracket |

---

## Editing

| Key | Description |
|-----|-------------|
| `x` | Delete character |
| `dd` | Delete line |
| `D` | Delete to end of line |
| `dw` | Delete word |
| `yy` | Yank (copy) line |
| `yw` | Yank word |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `u` | Undo |
| `Ctrl-r` | Redo |
| `cc` | Change line (delete and insert) |
| `cw` | Change word |
| `ciw` | Change inner word |
| `ci"` | Change inside quotes |
| `ci(` | Change inside parentheses |
| `.` | Repeat last change |
| `~` | Toggle case |
| `>>` | Indent line |
| `<<` | Unindent line |
| `J` | Join line below |

---

## Visual Mode

| Key | Description |
|-----|-------------|
| `v` | Start character selection |
| `V` | Start line selection |
| `Ctrl-v` | Start block selection |
| `y` | Yank selection |
| `d` | Delete selection |
| `c` | Change selection |
| `>` | Indent selection (stays in visual) |
| `<` | Unindent selection (stays in visual) |
| `J` | Move selection down |
| `K` | Move selection up |

---

## Search and Replace

| Key | Description |
|-----|-------------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search word under cursor |
| `Esc` | Clear search highlight |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all with confirm |

---

## Files and Buffers

| Key | Description |
|-----|-------------|
| `Space w` | Save file |
| `Space q` | Quit |
| `:w` | Save |
| `:q` | Quit |
| `:wq` or `:x` | Save and quit |
| `:q!` | Quit without saving |
| `:e filename` | Open file |

---

## Windows

| Key | Description |
|-----|-------------|
| `:sp` | Split horizontal |
| `:vsp` | Split vertical |
| `Ctrl-h` | Move to left window |
| `Ctrl-j` | Move to lower window |
| `Ctrl-k` | Move to upper window |
| `Ctrl-l` | Move to right window |
| `Ctrl-w =` | Equal size windows |
| `Ctrl-w _` | Maximize height |
| `Ctrl-w \|` | Maximize width |
| `:close` | Close window |
| `:only` | Close all other windows |

---

## Telescope (Fuzzy Finder)

| Key | Description |
|-----|-------------|
| `Space ff` | Find files |
| `Space fg` | Live grep (search in files) |
| `Space fb` | Find open buffers |
| `Space fr` | Recent files |
| `Space fh` | Help tags |
| `Space /` | Search in current file |

### Inside Telescope

| Key | Description |
|-----|-------------|
| `Ctrl-n/p` | Next/previous result |
| `Ctrl-j/k` | Next/previous result (alt) |
| `Enter` | Open selection |
| `Ctrl-x` | Open in horizontal split |
| `Ctrl-v` | Open in vertical split |
| `Esc` | Close telescope |

---

## Comments (Comment.nvim)

| Key | Description |
|-----|-------------|
| `gcc` | Toggle comment on line |
| `gc` (visual) | Toggle comment on selection |
| `gcap` | Comment a paragraph |

---

## Surround (nvim-surround)

| Key | Description |
|-----|-------------|
| `ys{motion}{char}` | Add surround |
| `ysiw"` | Surround word with quotes |
| `yss)` | Surround line with parens |
| `ds{char}` | Delete surround |
| `ds"` | Delete surrounding quotes |
| `cs{old}{new}` | Change surround |
| `cs"'` | Change `"` to `'` |
| `S{char}` (visual) | Surround selection |

---

## Git Signs

| Key | Description |
|-----|-------------|
| `]c` | Next hunk |
| `[c` | Previous hunk |

---

## Which-Key

Press `Space` and wait 500ms to see available keymaps.

---

## Command Mode Essentials

| Command | Description |
|---------|-------------|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:e file` | Edit file |
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Close buffer |
| `:Lazy` | Open plugin manager |
| `:checkhealth` | Diagnose issues |
| `:Mason` | (future) LSP installer |

---

## Tips for Beginners

### Think in Terms of: Verb + Noun

- `d` = delete, `y` = yank, `c` = change
- `w` = word, `$` = end of line, `}` = paragraph
- `dw` = delete word, `y$` = yank to end of line

### The "Inner" and "Around" Modifiers

- `i` = inner (inside), `a` = around (including)
- `ciw` = change inner word
- `da"` = delete around quotes (including quotes)
- `ci(` = change inside parentheses

### Common Combos

| Combo | Description |
|-------|-------------|
| `dd` then `p` | Move line down |
| `yy` then `p` | Duplicate line |
| `ci"` | Replace text inside quotes |
| `ggVG` | Select entire file |
| `gg=G` | Re-indent entire file |
| `*` then `cgn` | Change word, then `.` to repeat |

### Useful Habits

1. **Stay in normal mode** - Only enter insert mode to type, then escape
2. **Use `.` to repeat** - Do an edit once, repeat with `.`
3. **Use text objects** - `ciw`, `di(`, `ya"` are faster than selecting
4. **Don't use arrow keys** - Force yourself to use `hjkl`

---

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Create config directory
mkdir -p ~/.config/nvim

# Copy this init.lua to ~/.config/nvim/init.lua

# Open neovim - plugins will auto-install
nvim
```

First launch will install lazy.nvim and all plugins automatically.

---

## Adding LSP Later

When you're ready for IDE features, you can add:

```lua
-- Add to plugins table in init.lua
{ "neovim/nvim-lspconfig" },
{ "williamboman/mason.nvim" },
{ "williamboman/mason-lspconfig.nvim" },
```

This gives you autocompletion, go-to-definition, etc. for Elixir and other languages.
