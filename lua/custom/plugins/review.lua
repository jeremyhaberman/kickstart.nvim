-- PR review helpers for gitsigns. See diffview.lua for the full review workflow.
-- :ReviewBase                 Mark the PR's changes in every buffer, relative to the merge base with the target branch.
-- :ReviewBase origin/develop  Same, with another target branch.
-- :ReviewBaseReset            Go back to marking changes since the last commit.

-- The target branch to use when :ReviewBase gets no argument.
local function default_target()
  -- TODO(human)
  return 'origin/main'
end

return {
  {
    -- lazy.nvim merges this with the gitsigns specs in init.lua and kickstart/plugins/gitsigns.lua.
    'lewis6991/gitsigns.nvim',
    init = function()
      vim.api.nvim_create_user_command('ReviewBase', function(cmd)
        local target = cmd.args ~= '' and cmd.args or default_target()
        -- Use the merge base, not the target's tip, so the gutter matches `:DiffviewOpen target...HEAD`.
        local result = vim.system({ 'git', 'merge-base', target, 'HEAD' }, { text = true }):wait()
        if result.code ~= 0 then
          -- git exits with no message when the branches share no history.
          local reason = vim.trim(result.stderr) ~= '' and vim.trim(result.stderr) or ('no common commit with ' .. target)
          vim.notify('ReviewBase: ' .. reason, vim.log.levels.ERROR)
          return
        end
        require('gitsigns').change_base(vim.trim(result.stdout), true)
        vim.notify('ReviewBase: showing changes since the merge base with ' .. target)
      end, { nargs = '?', desc = 'Show PR changes in gitsigns, relative to the merge base with a target branch' })

      vim.api.nvim_create_user_command('ReviewBaseReset', function()
        require('gitsigns').reset_base(true)
      end, { desc = 'Show changes since the last commit in gitsigns again' })
    end,
  },
}
