-- Highlight, edit, and navigate code

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  branch = 'master',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  lazy = false,
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'elixir', 'heex', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    -- Disabling indentation for elixir because of unresolved issues with pipe chains
    -- https://elixirforum.com/t/neovim-indentation-bug-with-more-than-one-on-a-line-keeps-wrongly-adding-another-indentation/64791/8
    indent = { enable = true, disable = { 'ruby', 'elixir' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<A-o>',
        scope_incremental = '<A-O>',
        node_incremental = '<A-o>',
        node_decremental = '<A-i>',
      },
    },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
