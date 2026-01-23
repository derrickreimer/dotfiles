# Neovim Cheatsheet

Leader key: `<Space>`

## Basic/Core

| Keymap       | Description                   |
|--------------|-------------------------------|
| `<Esc>`      | Clear search highlights       |
| `<leader>q`  | Open diagnostic quickfix list |
| `<Esc><Esc>` | Exit terminal mode            |

## Window Navigation

| Keymap  | Description                |
|---------|----------------------------|
| `<C-h>` | Move focus to left window  |
| `<C-l>` | Move focus to right window |
| `<C-j>` | Move focus to lower window |
| `<C-k>` | Move focus to upper window |

## Telescope Search (`<leader>s*`)

| Keymap             | Description                    |
|--------------------|--------------------------------|
| `<leader>sh`       | Search Help                    |
| `<leader>sk`       | Search Keymaps                 |
| `<leader>sf`       | Search Files                   |
| `<leader>ss`       | Search Select Telescope        |
| `<leader>sw`       | Search current Word            |
| `<leader>sg`       | Search by Grep                 |
| `<leader>sd`       | Search Diagnostics             |
| `<leader>sr`       | Search Resume                  |
| `<leader>s.`       | Search Recent Files            |
| `<leader>s/`       | Search in Open Files           |
| `<leader>sn`       | Search Neovim config files     |
| `<leader>/`        | Fuzzy search in current buffer |
| `<leader><leader>` | Find existing buffers          |

## LSP (`gr*` prefix)

| Keymap       | Description          |
|--------------|----------------------|
| `grn`        | Rename symbol        |
| `gra`        | Code Action          |
| `grr`        | Goto References      |
| `gri`        | Goto Implementation  |
| `grd`        | Goto Definition      |
| `grD`        | Goto Declaration     |
| `gO`         | Document Symbols     |
| `gW`         | Workspace Symbols    |
| `grt`        | Goto Type Definition |
| `<leader>th` | Toggle Inlay Hints   |

## Formatting

| Keymap      | Description   |
|-------------|---------------|
| `<leader>f` | Format buffer |

## Fugitive (`:Git` or `:G`)

| Command         | Description           |
|-----------------|-----------------------|
| `:Git` or `:G`  | Open git status       |
| `:Git blame`    | Inline git blame      |
| `:Git diff`     | Show diff             |
| `:Gvdiffsplit`  | Vertical diff split   |
| `:Git log`      | Show git log          |
| `:Git push`     | Push to remote        |
| `:Git pull`     | Pull from remote      |

**In fugitive status buffer:**

| Keymap | Description                   |
|--------|-------------------------------|
| `s`    | Stage file/hunk               |
| `u`    | Unstage file/hunk             |
| `-`    | Toggle stage/unstage          |
| `=`    | Toggle inline diff            |
| `cc`   | Commit                        |
| `ca`   | Commit --amend                |
| `X`    | Discard change                |
| `<CR>` | Open file                     |
| `o`    | Open in horizontal split      |
| `gO`   | Open in vertical split        |
| `dv`   | Open vertical diff split      |
| `g?`   | Show help                     |

## Git/Gitsigns (`<leader>h*`)

| Keymap       | Description              |
|--------------|--------------------------|
| `]c`         | Next git change          |
| `[c`         | Previous git change      |
| `<leader>hs` | Stage hunk               |
| `<leader>hr` | Reset hunk               |
| `<leader>hS` | Stage buffer             |
| `<leader>hu` | Undo stage hunk          |
| `<leader>hR` | Reset buffer             |
| `<leader>hp` | Preview hunk             |
| `<leader>hb` | Blame line               |
| `<leader>hd` | Diff against index       |
| `<leader>hD` | Diff against last commit |
| `<leader>tb` | Toggle blame line        |
| `<leader>tD` | Toggle show deleted      |

## Debug (F keys, `<leader>b`)

| Keymap      | Description                |
|-------------|----------------------------|
| `<F5>`      | Start/Continue debugging   |
| `<F1>`      | Step Into                  |
| `<F2>`      | Step Over                  |
| `<F3>`      | Step Out                   |
| `<F7>`      | Toggle Debug UI            |
| `<leader>b` | Toggle Breakpoint          |
| `<leader>B` | Set Conditional Breakpoint |

## File Explorer

| Keymap | Description                          |
|--------|--------------------------------------|
| `\`    | NeoTree reveal (also closes NeoTree) |

## Surround (`sa*`, `sd*`, `sr*`)

| Keymap   | Description                               |
|----------|-------------------------------------------|
| `saiw)`  | Surround word with parentheses            |
| `sd'`    | Delete surrounding quotes                 |
| `sr)'`   | Replace parens with quotes                |
| `saiwt`  | Surround word with tag (prompts for name) |
| `sdt`    | Delete surrounding tag                    |
| `srt`    | Replace/rename tag                        |

**Tag examples:**
- `saiwt` then `div<CR>` wraps word in `<div>word</div>`
- `saiwt` then `div className="box"<CR>` adds attributes
- `sdt` removes `<tag>...</tag>`

---
Press `q` or `<Esc>` to close this window.
