-- Highlight, edit, and navigate code

-- Shim: archived nvim-treesitter master registers these directives with the pre-0.11 single-node match API; on Neovim 0.12+ match[id] is always TSNode[], so they crash. Drop when migrating to the `main` branch.
local function patch_treesitter_directives_for_nvim_012()
  local query = require('vim.treesitter.query')

  local function first_node(captures)
    if type(captures) == 'table' and captures[1] ~= nil then
      return captures[1]
    end
    return captures
  end

  local html_script_type_languages = {
    importmap = 'json',
    module = 'javascript',
    ['application/ecmascript'] = 'javascript',
    ['text/ecmascript'] = 'javascript',
  }

  local non_filetype_match_injection_language_aliases = {
    ex = 'elixir',
    pl = 'perl',
    sh = 'bash',
    uxn = 'uxntal',
    ts = 'typescript',
  }

  local function resolve_markdown_info_string(alias)
    local match = vim.filetype.match { filename = 'a.' .. alias }
    return match or non_filetype_match_injection_language_aliases[alias] or alias
  end

  query.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
    local node = first_node(match[pred[2]])
    if not node then return end
    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata['injection.language'] = configured
    else
      local parts = vim.split(type_attr_value, '/', {})
      metadata['injection.language'] = parts[#parts]
    end
  end, { force = true })

  query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
    local node = first_node(match[pred[2]])
    if not node then return end
    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata['injection.language'] = resolve_markdown_info_string(alias)
  end, { force = true })

  query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = first_node(match[id])
    if not node then return end
    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ''
    if not metadata[id] then metadata[id] = {} end
    metadata[id].text = text:lower()
  end, { force = true })
end

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  branch = 'master',
  lazy = false,
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
    patch_treesitter_directives_for_nvim_012()
  end,
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
