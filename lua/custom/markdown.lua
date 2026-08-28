-- Small markdown editing helpers that don't justify a plugin dependency.
local M = {}

-- A list item is an indent, a bullet ('- ', '* ', '+ ') or a number
-- ('1. ', '1) '), then everything after it.
local LIST_ITEM_PATTERNS = {
  '^(%s*)([-*+]%s+)(.*)$',
  '^(%s*)(%d+[.)]%s+)(.*)$',
}

--- Split a markdown list item into its indent, its bullet, and the rest.
---@param line string
---@return string|nil indent, string|nil marker, string|nil rest
local function split_list_item(line)
  for _, pattern in ipairs(LIST_ITEM_PATTERNS) do
    local indent, marker, rest = line:match(pattern)
    if indent then
      return indent, marker, rest
    end
  end
  return nil
end

--- Advance the checkbox state on one line of markdown.
--- An unchecked box becomes checked. Any other marker ('[x]', '[X]', '[/]',
--- '[-]') counts as checked, so toggling clears it. A list item with no
--- checkbox at all gains an unchecked one. Anything else is left alone.
---@param line string full text of the line, e.g. '  - [ ] buy milk'
---@return string|nil new text for the line, or nil to leave it unchanged
local function toggled_line(line)
  local indent, marker, rest = split_list_item(line)
  if not indent then
    return nil
  end

  local state, body = rest:match('^%[(.)%]%s?(.*)$')
  local box
  if state then
    box = state == ' ' and '[x]' or '[ ]'
  else
    -- No checkbox yet, so add an empty one and keep the text as the body.
    box, body = '[ ]', rest
  end

  return indent .. marker .. box .. (body == '' and '' or ' ' .. body)
end

--- Toggle the checkbox on the line under the cursor.
function M.toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  local new_line = toggled_line(line)
  if new_line == nil or new_line == line then
    return
  end
  vim.api.nvim_set_current_line(new_line)
end

--- Bind the helpers in every markdown buffer.
function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Markdown editing keymaps',
    group = vim.api.nvim_create_augroup('markdown-helpers', { clear = true }),
    pattern = 'markdown',
    callback = function(args)
      vim.keymap.set('n', '<leader>mc', M.toggle_checkbox, { buffer = args.buf, desc = 'Toggle [C]heckbox' })
    end,
  })
end

-- Exposed for testing.
M._toggled_line = toggled_line

return M
