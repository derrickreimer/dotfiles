# TMUX CHEATSHEET

Based on your `~/.tmux.conf` configuration.

All commands start with the **PREFIX: `Ctrl-b`**

Notation: `C-b` means Ctrl-b, then release, then press the next key

---

## Sessions

| Command                     | Description                                     |
| --------------------------- | ----------------------------------------------- |
| `tmux`                      | Start new unnamed session                       |
| `tmux new -s myproject`     | Start new session named "myproject"             |
| `tmux ls`                   | List all sessions                               |
| `tmux attach`               | Attach to last session                          |
| `tmux attach -t myproject`  | Attach to session named "myproject"             |
| `tmux kill-session -t name` | Kill a specific session                         |
| `C-b d`                     | Detach from current session (leaves it running) |
| `C-b $`                     | Rename current session                          |
| `C-b s`                     | Session picker (interactive)                    |
| `C-b :kill-session`         | Kill current session                            |
| `C-b r`                     | Reload config (custom keybinding)               |

---

## Windows (tabs)

| Command   | Description                                     |
| --------- | ----------------------------------------------- |
| `C-b c`   | Create new window (opens in current directory)  |
| `C-b ,`   | Rename current window                           |
| `C-b &`   | Kill current window (confirm with y)            |
| `C-b n`   | Next window                                     |
| `C-b p`   | Previous window                                 |
| `C-b 1-9` | Jump to window by number                        |
| `C-b w`   | Window picker (interactive, shows all sessions) |

---

## Panes (splits)

### Creating panes (your custom bindings)

| Command  | Description                       |
| -------- | --------------------------------- |
| `C-b \|` | Split horizontally (side by side) |
| `C-b -`  | Split vertically (top/bottom)     |

### Navigating panes (vim-style)

| Command | Description               |
| ------- | ------------------------- |
| `C-b h` | Move to pane on the left  |
| `C-b j` | Move to pane below        |
| `C-b k` | Move to pane above        |
| `C-b l` | Move to pane on the right |

### Resizing panes (hold prefix, repeatable)

| Command | Description  |
| ------- | ------------ |
| `C-b H` | Resize left  |
| `C-b J` | Resize down  |
| `C-b K` | Resize up    |
| `C-b L` | Resize right |

### Other pane commands

| Command     | Description                              |
| ----------- | ---------------------------------------- |
| `C-b x`     | Kill current pane (confirm with y)       |
| `C-b z`     | Toggle pane zoom (fullscreen)            |
| `C-b !`     | Convert pane to its own window           |
| `C-b q`     | Show pane numbers (press number to jump) |
| `C-b {`     | Swap pane with previous                  |
| `C-b }`     | Swap pane with next                      |
| `C-b Space` | Cycle through pane layouts               |

### Mouse (enabled in your config)

| Action      | Description    |
| ----------- | -------------- |
| Click       | Select pane    |
| Drag border | Resize pane    |
| Scroll      | Scroll in pane |

---

## Copy Mode (vim-style)

| Command | Description                                  |
| ------- | -------------------------------------------- |
| `C-b v` | Enter copy mode (your custom binding)        |
| `C-b [` | Enter copy mode (default binding also works) |

### Inside copy mode

| Key           | Description                                         |
| ------------- | --------------------------------------------------- |
| `h/j/k/l`     | Navigate (vim keys)                                 |
| `C-u` / `C-d` | Page up / Page down                                 |
| `g` / `G`     | Jump to top / bottom                                |
| `/`           | Search forward                                      |
| `?`           | Search backward                                     |
| `n` / `N`     | Next / previous search match                        |
| `v`           | Start selection                                     |
| `y`           | Copy selection and exit (copies to macOS clipboard) |
| `q`           | Exit copy mode without copying                      |

---

## Command Mode

| Command | Description        |
| ------- | ------------------ |
| `C-b :` | Enter command mode |

### Useful commands

| Command                     | Description            |
| --------------------------- | ---------------------- |
| `:source-file ~/.tmux.conf` | Reload config          |
| `:kill-session`             | Kill current session   |
| `:kill-server`              | Kill tmux entirely     |
| `:list-keys`                | Show all key bindings  |
| `:list-commands`            | Show all tmux commands |

---

## Your Custom Shortcuts Summary

| Command       | Description                                |
| ------------- | ------------------------------------------ |
| `C-b r`       | Reload config (shows confirmation message) |
| `C-b \|`      | Split horizontal (instead of %)            |
| `C-b -`       | Split vertical (instead of ")              |
| `C-b h/j/k/l` | Navigate panes (vim-style)                 |
| `C-b H/J/K/L` | Resize panes (vim-style)                   |
| `C-b v`       | Enter copy mode                            |

---

## Common Workflows

### Start a new project workspace

```bash
tmux new -s savvycal                    # Create session
# C-b |                                 # Split for editor + terminal
# C-b c                                 # New window for server
# C-b ,                                 # Rename window to "server"
# C-b 1                                 # Jump back to first window
```

### Detach and resume later

```bash
# C-b d                                 # Detach
tmux attach -t savvycal                 # Resume later (even after reboot*)
```

### Quick pane management

```
C-b z                                   # Zoom pane to fullscreen
C-b z                                   # Un-zoom back to split
C-b x                                   # Close pane when done
```

### Copying text

```
C-b v                                   # Enter copy mode
/searchterm                             # Find what you need
v                                       # Start selection
y                                       # Yank (copies to system clipboard)
Cmd-v                                   # Paste anywhere on macOS
```

---

## Tips

- Sessions survive terminal close but **not system reboot** (look into tmux-resurrect plugin if you want persistence)
- Your status bar shows:
  - **Left:** Session name
  - **Center:** Window list (current highlighted in blue)
  - **Right:** Date and time
- Windows are numbered starting at 1 (not 0)
- Panes are also numbered starting at 1
- Mouse is enabled—you can click to select panes, drag borders to resize, and scroll to see history
