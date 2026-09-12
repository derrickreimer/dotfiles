# HERDR CHEATSHEET

Aligned with your tmux setup (`~/.tmux.conf`).

Herdr terms: **workspace** ≈ tmux session, **tab** ≈ tmux window, **pane** ≈ tmux pane.

All commands start with the **PREFIX: `Ctrl-b`**

Notation: `C-b` means Ctrl-b, then release, then press the next key

---

## Sessions / workspaces

| Command                     | Description                                          |
| --------------------------- | ---------------------------------------------------- |
| `herdr`                     | Attach to the default session                        |
| `herdr --session myproject` | Attach to (or create) a named session                |
| `herdr session list`        | List named sessions                                  |
| `herdr server stop`         | Stop the server and all panes                        |
| `C-b d` / `C-b q`           | Detach (leaves everything running)                   |
| `C-b s`                     | Workspace picker                                     |
| `C-b w` / `C-b g`           | Goto navigator                                       |
| `j` / `k`                   | Next / previous space (in navigate mode)             |
| `C-b $`                     | Rename current workspace                             |
| `C-b r`                     | Reload config                                        |

---

## Tabs (tmux windows)

| Command       | Description                                    |
| ------------- | ---------------------------------------------- |
| `C-b c`       | Create new tab (opens in current directory)    |
| `C-b ,`       | Rename current tab                             |
| `C-b &`       | Kill current tab                               |
| `C-b n`       | Next tab                                       |
| `C-b p`       | Previous tab                                   |
| `C-b 1-9`     | Jump to tab by number                          |
| `Alt-1-9`     | Jump to tab by number (no prefix)              |
| `C-b <`       | Move tab left                                  |
| `C-b >`       | Move tab right                                 |

---

## Panes

### Creating panes

| Command  | Description                       |
| -------- | --------------------------------- |
| `C-b \|` | Split horizontally (side by side) |
| `C-b -`  | Split vertically (top/bottom)     |

### Navigating panes (vim-style)

| Command         | Description               |
| --------------- | ------------------------- |
| `C-b h` / `M-h` | Move to pane on the left  |
| `C-b j` / `M-j` | Move to pane below        |
| `C-b k` / `M-k` | Move to pane above        |
| `C-b l` / `M-l` | Move to pane on the right |

`M-` is Alt. On macOS this needs Option to be sent as Alt (Ghostty: `macos-option-as-alt`).

### Resizing panes

| Command | Description  |
| ------- | ------------ |
| `C-b H` | Resize left  |
| `C-b J` | Resize down  |
| `C-b K` | Resize up    |
| `C-b L` | Resize right |
| `C-b R` | Resize mode  |

### Other pane commands

| Command | Description                         |
| ------- | ----------------------------------- |
| `C-b x` | Kill current pane                   |
| `C-b z` | Toggle pane zoom (fullscreen)       |
| `C-b {` | Swap with pane on the left          |
| `C-b }` | Swap with pane on the right         |
| `C-b b` | Toggle sidebar                      |

### Mouse (enabled)

| Action      | Description    |
| ----------- | -------------- |
| Click       | Select pane    |
| Drag border | Resize pane    |
| Scroll      | Scroll in pane |
| Drag select | Copy to clipboard |

---

## Copy Mode (vim-style)

| Command | Description                           |
| ------- | ------------------------------------- |
| `C-b v` | Enter copy mode                       |
| `C-b [` | Enter copy mode (tmux default alias)  |

### Inside copy mode

| Key           | Description                                         |
| ------------- | --------------------------------------------------- |
| `h/j/k/l`     | Navigate (vim keys)                                 |
| `C-u` / `C-d` | Page up / Page down                                 |
| `/`           | Search forward                                      |
| `?`           | Search backward                                     |
| `n` / `N`     | Next / previous search match                        |
| `v`           | Start selection                                     |
| `y`           | Copy selection and exit (copies to macOS clipboard) |
| `q`           | Exit copy mode without copying                      |

---

## Custom shortcuts summary

| Command       | Description                    |
| ------------- | ------------------------------ |
| `C-b r`       | Reload config                  |
| `C-b \|`      | Split horizontal (side by side)|
| `C-b -`       | Split vertical (top/bottom)    |
| `C-b h/j/k/l` | Navigate panes                 |
| `C-b H/J/K/L` | Resize panes                   |
| `C-b v`       | Enter copy mode                |
| `C-b d`       | Detach                         |

---

## Tips

- Detach survives terminal close. `herdr server stop` is what actually kills panes.
- Status bar (bottom): tabs on the left, date and time on the right
- Tabs are numbered starting at 1
- Mouse is enabled — click to select panes, drag borders to resize, drag to copy
- `C-b ?` shows live keybindings (always matches this config)
