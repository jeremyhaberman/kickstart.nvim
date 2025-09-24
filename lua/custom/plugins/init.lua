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
              git = true,
              file = true,
              folder = true,
              folder_arrow = true,
            },
            glyphs = {
              folder = {
                arrow_closed = "",
                arrow_open = "",
              },
              git = {
                unstaged = "",
                staged = "",
                unmerged = "",
                renamed = "",
                untracked = "",
                deleted = "",
                ignored = "",
              },
            },
            padding = " ",
            web_devicons = {
              folder = {
                enable = true,
                color = true,
              },
              file = {
                enable = true,
                color = true,
              },
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

      -- Toggle with <leader>e
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
    end,
  },
}
