-- Side-by-side diffs with a file panel, for reviewing a whole branch or PR.
-- PR review: check the PR out in a worktree, then `:DiffviewOpen origin/main...HEAD`.
-- The three dots diff against the merge base, which matches the Azure DevOps Files tab.
-- The right-hand side is the real file on disk, so LSP (gd, grr, hover) works there.
return {
  {
    'sindrets/diffview.nvim',
    -- Load only when one of its commands is run.
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh' },
  },
}
