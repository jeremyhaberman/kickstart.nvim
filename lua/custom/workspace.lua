-- Open the ACE change workspace (plans, tickets, research) for the current branch.
-- The workspace can live outside the repo, so Neo-tree and Telescope don't see it.
local M = {}

--- Run a git command and return its trimmed output, or nil if it fails.
---@param args string[]
---@return string|nil
local function git(args)
  local result = vim.system(vim.list_extend({ 'git' }, args), { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout)
end

--- Read `paths.root` from `.ace.json`. Look in the current checkout first, then in the
--- main checkout, because `.ace.json` is often git-ignored and missing from worktrees.
---@param toplevel string root of the current checkout
---@return string plans root, as an absolute path
local function plans_root(toplevel)
  local common_dir = git { 'rev-parse', '--path-format=absolute', '--git-common-dir' }
  local checkouts = { toplevel, common_dir and vim.fs.dirname(common_dir) }

  local root = 'docs/plans'
  for _, checkout in ipairs(checkouts) do
    local ok, config = pcall(function()
      return vim.json.decode(table.concat(vim.fn.readfile(checkout .. '/.ace.json'), '\n'))
    end)
    if ok and type(config) == 'table' and config.paths and config.paths.root then
      root = config.paths.root
      break
    end
  end

  root = vim.fs.normalize(root) -- expands a leading ~
  if not vim.startswith(root, '/') then
    root = toplevel .. '/' .. root
  end
  return root
end

--- Pick the workspace directory for a branch from the directories under the plans root.
---@param root string plans root, as an absolute path
---@param branch string current branch, e.g. '4560-urk-page-readiness'
---@return string|nil absolute path of the workspace, or nil if none matches
local function find_workspace(root, branch)
  if branch == '' or vim.fn.isdirectory(root) == 0 then
    return nil
  end

  local exact = root .. '/' .. branch
  if vim.fn.isdirectory(exact) == 1 then
    return exact
  end

  -- ACE keeps the branch name when it renames a workspace, so fall back to the
  -- ticket ID at the start of the name: '4560' or 'eng-1478'.
  local ticket = branch:match '^(%a*%-?%d+)-'
  if not ticket then
    return nil
  end
  local matches = {}
  for name, kind in vim.fs.dir(root) do
    if kind == 'directory' and vim.startswith(name, ticket .. '-') then
      table.insert(matches, root .. '/' .. name)
    end
  end
  -- Two workspaces for one ticket is ambiguous, so don't guess.
  return #matches == 1 and matches[1] or nil
end

--- Work out the current branch's workspace, or warn and return nil.
---@return string|nil
function M.path()
  local toplevel = git { 'rev-parse', '--show-toplevel' }
  if not toplevel then
    vim.notify('Not in a git repo', vim.log.levels.WARN)
    return nil
  end

  local root = plans_root(toplevel)
  local branch = git { 'branch', '--show-current' } or ''
  local workspace = find_workspace(root, branch)
  if not workspace then
    vim.notify('No workspace for branch "' .. branch .. '" in ' .. root, vim.log.levels.WARN)
  end
  return workspace
end

--- Find files in the workspace, without changing the working directory.
function M.search()
  local workspace = M.path()
  if workspace then
    require('telescope.builtin').find_files { cwd = workspace, prompt_title = 'Workspace: ' .. vim.fs.basename(workspace) }
  end
end

--- Open the workspace in its own tab, with the tab's working directory set to it.
--- If a tab already has that working directory, switch to it instead.
function M.open_tab()
  local workspace = M.path()
  if not workspace then
    return
  end

  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tab)) == workspace then
      vim.api.nvim_set_current_tabpage(tab)
      return
    end
  end

  vim.cmd.tabnew()
  vim.cmd.tcd(vim.fn.fnameescape(workspace))
  vim.cmd 'Neotree'
end

function M.setup()
  vim.keymap.set('n', '<leader>sp', M.search, { desc = '[S]earch [P]lan workspace files' })
  vim.keymap.set('n', '<leader>wp', M.open_tab, { desc = 'Open [P]lan workspace in a tab' })
end

-- Exposed for testing.
M._find_workspace = find_workspace

return M
