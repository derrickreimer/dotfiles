-- Cheatsheet floating window module
local M = {}

function M.open()
  -- Get the cheatsheet file path
  local cheatsheet_path = vim.fn.stdpath('config') .. '/doc/cheatsheet.md'

  -- Read the cheatsheet content
  local lines = {}
  local file = io.open(cheatsheet_path, 'r')
  if file then
    for line in file:lines() do
      table.insert(lines, line)
    end
    file:close()
  else
    lines = { 'Cheatsheet not found at: ' .. cheatsheet_path }
  end

  -- Calculate window dimensions (80% of screen, centered)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create a scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set buffer options
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Cheatsheet ',
    title_pos = 'center',
  })

  -- Set window options
  vim.api.nvim_set_option_value('wrap', true, { win = win })
  vim.api.nvim_set_option_value('cursorline', true, { win = win })

  -- Close window keymaps
  local close_keys = { 'q', '<Esc>' }
  for _, key in ipairs(close_keys) do
    vim.keymap.set('n', key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf, noremap = true, silent = true })
  end
end

return M
