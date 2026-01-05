return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  keys = {
    {
      '<leader>sR',
      function()
        require('grug-far').open()
      end,
      desc = '[S]earch and [R]eplace (project)',
    },
    {
      '<leader>sW',
      function()
        require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
      end,
      desc = '[S]earch current [W]ord (grug-far)',
    },
    {
      '<leader>sW',
      function()
        require('grug-far').with_visual_selection()
      end,
      desc = '[S]earch visual selection',
      mode = 'v',
    },
  },
  opts = {
    windowCreationCommand = 'vsplit',
    startInInsertMode = true,
    transient = false,
    icons = {
      enabled = true,
    },
    folding = {
      enabled = true,
      foldlevel = 0,
    },
  },
}
