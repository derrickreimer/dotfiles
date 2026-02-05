-- Scrollbar with git and search indicators

return {
  'petertriho/nvim-scrollbar',
  event = 'VimEnter',
  dependencies = { 'lewis6991/gitsigns.nvim' },
  config = function()
    require('scrollbar').setup()
    require('scrollbar.handlers.gitsigns').setup()
  end,
}
