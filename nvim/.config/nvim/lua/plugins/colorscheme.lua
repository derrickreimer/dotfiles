-- Colorscheme
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      styles = {
        comments = { italic = false }, -- Disable italics in comments
      },
    }

    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'tokyonight-night'

    -- Make Telescope background match the editor background
    vim.api.nvim_set_hl(0, 'TelescopeNormal', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopeTitle', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { link = 'Normal' })
  end,
}
