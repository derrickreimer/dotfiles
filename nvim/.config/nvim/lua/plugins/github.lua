-- Open current file in GitHub

local M = {}

-- Run a git command and return the output (trimmed)
local function git(args)
  local result = vim.fn.systemlist('git ' .. args)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result[1]
end

-- Get the git root directory
local function get_git_root()
  return git 'rev-parse --show-toplevel'
end

-- Get the remote URL for origin
local function get_remote_url()
  return git 'remote get-url origin'
end

-- Get the current branch name
local function get_current_branch()
  local branch = git 'symbolic-ref --short HEAD'
  if branch then
    return branch
  end
  -- Detached HEAD, return nil
  return nil
end

-- Get the default branch (main or master)
local function get_default_branch()
  -- Try to get default branch from origin/HEAD
  local ref = git 'symbolic-ref refs/remotes/origin/HEAD'
  if ref then
    return ref:match 'origin/(.+)$'
  end
  -- Fallback: check if main or master exists
  if git 'show-ref --verify --quiet refs/heads/main' == '' or vim.v.shell_error == 0 then
    local main_check = vim.fn.system 'git show-ref --verify --quiet refs/heads/main'
    if vim.v.shell_error == 0 then
      return 'main'
    end
  end
  return 'master'
end

-- Parse GitHub URL from remote URL
-- Handles: git@github.com:owner/repo.git and https://github.com/owner/repo.git
local function parse_github_url(remote_url)
  if not remote_url then
    return nil
  end

  local owner, repo

  -- SSH format: git@github.com:owner/repo.git
  owner, repo = remote_url:match 'git@github%.com:([^/]+)/(.+)%.git$'
  if owner and repo then
    return 'https://github.com/' .. owner .. '/' .. repo
  end

  -- SSH format without .git: git@github.com:owner/repo
  owner, repo = remote_url:match 'git@github%.com:([^/]+)/(.+)$'
  if owner and repo then
    return 'https://github.com/' .. owner .. '/' .. repo
  end

  -- HTTPS format: https://github.com/owner/repo.git
  owner, repo = remote_url:match 'https://github%.com/([^/]+)/(.+)%.git$'
  if owner and repo then
    return 'https://github.com/' .. owner .. '/' .. repo
  end

  -- HTTPS format without .git: https://github.com/owner/repo
  owner, repo = remote_url:match 'https://github%.com/([^/]+)/(.+)$'
  if owner and repo then
    return 'https://github.com/' .. owner .. '/' .. repo
  end

  return nil
end

-- Build the GitHub blob URL
local function build_github_url(use_default_branch)
  local git_root = get_git_root()
  if not git_root then
    vim.notify('Not in a git repository', vim.log.levels.ERROR)
    return nil
  end

  local remote_url = get_remote_url()
  if not remote_url then
    vim.notify('No remote configured', vim.log.levels.ERROR)
    return nil
  end

  local github_base = parse_github_url(remote_url)
  if not github_base then
    vim.notify('Remote is not a GitHub repository', vim.log.levels.ERROR)
    return nil
  end

  -- Get branch
  local branch
  if use_default_branch then
    branch = get_default_branch()
  else
    branch = get_current_branch() or get_default_branch()
  end

  -- Get relative file path
  local file_path = vim.fn.expand '%:p'
  local relative_path = file_path:sub(#git_root + 2) -- +2 for trailing slash

  -- Get line number(s)
  local mode = vim.fn.mode()
  local line_anchor
  if mode == 'v' or mode == 'V' or mode == '\22' then
    -- Visual mode: get selection range
    local start_line = vim.fn.line 'v'
    local end_line = vim.fn.line '.'
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    line_anchor = '#L' .. start_line .. '-L' .. end_line
  else
    -- Normal mode: current line
    local line = vim.fn.line '.'
    line_anchor = '#L' .. line
  end

  return github_base .. '/blob/' .. branch .. '/' .. relative_path .. line_anchor
end

-- Open in browser
local function open_url(url)
  vim.fn.system { 'open', url }
end

-- Main function to open file in GitHub
function M.open_in_github(use_default_branch)
  local url = build_github_url(use_default_branch)
  if url then
    open_url(url)
    vim.notify('Opened in GitHub', vim.log.levels.INFO)
  end
end

-- Return lazy.nvim plugin spec
return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins',
  name = 'github-open',
  lazy = false,
  config = function()
    -- Keybindings for opening in GitHub
    vim.keymap.set({ 'n', 'v' }, '<leader>ho', function()
      M.open_in_github(false)
    end, { desc = 'Git [o]pen in GitHub' })

    vim.keymap.set({ 'n', 'v' }, '<leader>hO', function()
      M.open_in_github(true)
    end, { desc = 'Git [O]pen in GitHub (default branch)' })
  end,
}
