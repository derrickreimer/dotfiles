-- Basic Autocommands
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Switch to absolute line numbers in command mode
vim.api.nvim_create_autocmd('CmdlineEnter', {
  desc = 'Show absolute line numbers in command mode',
  group = vim.api.nvim_create_augroup('cmdline-linenumbers', { clear = true }),
  callback = function()
    vim.o.relativenumber = false
    vim.cmd 'redraw'
  end,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  desc = 'Restore relative line numbers after command mode',
  group = vim.api.nvim_create_augroup('cmdline-linenumbers-leave', { clear = true }),
  callback = function()
    vim.o.relativenumber = true
  end,
})

-- Treat MJML files as HTML for syntax highlighting and tag completion
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.mjml',
  callback = function()
    vim.bo.filetype = 'html'
  end,
})
