-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Disable netrw (Vim's built-in file explorer)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require('nvim-tree').setup {
        view = {
          width = 40,
          side = 'left',
        },
        renderer = {
          group_empty = true, -- Collapse empty folders
          icons = {
            show = {
              git = false,
              file = false,
              folder = false,
              folder_arrow = false,
            },
          },
          special_files = {},
        },
        filters = {
          dotfiles = false, -- Show .env, .gitignore, etc.
        },
        git = {
          ignore = false, -- Show files in .gitignore
        },
      }

      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
    end,
  },
}
