-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    -- When opening a file, neo-tree targets the most recently visited window
    -- (see `prior_windows` in neo-tree.lua). Without this, coming from a
    -- fugitive status/blame window makes the file replace *it* instead of the
    -- editing window. This list replaces the defaults, so keep them.
    open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'edgy', 'fugitive', 'fugitiveblame' },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function(arg)
          vim.cmd [[
          setlocal relativenumber
        ]]
        end,
      },
    },
  },
}
