-- Seamless CTRL+<hjkl> between nvim windows and tmux panes.
-- At the edge of the last nvim window, the plugin runs `tmux select-pane`.
-- The matching tmux side is in ~/.tmux.conf ("pane navigation").
return {
  {
    'christoomey/vim-tmux-navigator',
    init = function()
      -- The `keys` table below defines the mappings; stop the plugin adding its own.
      vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
    },
    keys = {
      { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Move focus to the left window' },
      { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Move focus to the lower window' },
      { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Move focus to the upper window' },
      { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Move focus to the right window' },
    },
  },
}
