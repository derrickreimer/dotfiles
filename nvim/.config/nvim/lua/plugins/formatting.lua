-- Autoformat

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = function()
    -- Check if project has eslint-plugin-prettier configured
    -- If so, eslint_d handles both linting fixes AND prettier formatting in one pass
    -- Otherwise, run eslint_d for fixes, then prettierd for formatting
    local function has_eslint_prettier()
      local root = vim.fn.findfile('package.json', '.;')
      if root == '' then
        return false
      end

      local file = io.open(root, 'r')
      if not file then
        return false
      end

      local content = file:read '*all'
      file:close()
      return content:find 'eslint%-plugin%-prettier' ~= nil
    end

    -- Dynamic formatter selection for JS/TS files
    local function js_formatters()
      if has_eslint_prettier() then
        -- eslint-plugin-prettier runs prettier as an eslint rule
        -- so eslint_d alone handles everything in a single pass
        return { 'eslint_d' }
      else
        -- Run eslint_d for autofixes, then prettier for formatting
        -- Use prettierd (daemon) for speed
        return { 'eslint_d', 'prettierd' }
      end
    end

    return {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 1000,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        elixir = { 'mix' },
        eelixir = { 'mix' },
        heex = { 'mix' },
        javascript = js_formatters,
        typescript = js_formatters,
        javascriptreact = js_formatters,
        typescriptreact = js_formatters,
        markdown = { { 'prettierd', 'prettier', stop_after_first = true } },
      },
      formatters = {
        eslint_d = {
          require_cwd = true,
        },
      },
    }
  end,
}
