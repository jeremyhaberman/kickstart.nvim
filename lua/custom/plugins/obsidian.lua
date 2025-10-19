return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
    config = function()
      require('obsidian').setup {
        workspaces = {
          {
            name = 'auditminer',
            path = '~/Documents/AuditMiner',
          },
          {
            name = 'projects',
            path = '~/Documents/Projects/',
          },
          {
            name = 'personal',
            path = '~/Documents/Knowledge/',
          },
        },
        notes_subdir = '2 Seeds',
        new_notes_location = 'notes_subdir',
        daily_notes = {
          folder = '1 Journal',
        },
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },
        ui = {
          enable = true,
        },
        attachments = {
          img_folder = 'z_attachments',
        },
      }

      local cmp = require 'cmp'

      cmp.setup {
        -- Other nvim-cmp settings...
        sources = cmp.config.sources {
          { name = 'obsidian' },
          { name = 'path' },
        },
        mapping = cmp.mapping.preset.insert {
          -- Manually trigger completion with `<C-space>`
          ['<C-Space>'] = cmp.mapping.complete(),
        },
      }

      -- Autocmd to configure nvim-cmp for markdown files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          cmp.setup.buffer {
            -- Disable buffer source (word
            -- completion) for markdown
            sources = { { name = 'obsidian' }, { name = 'path' } },
          }
        end,
      })

      -- Set up custom keymaps after setup
      vim.keymap.set('n', 'gf', function()
        return require('obsidian').util.gf_passthrough()
      end, { noremap = false, expr = true, buffer = true, desc = 'Follow Obsidian link' })

      vim.keymap.set('n', '<leader>oc', function()
        return require('obsidian').util.toggle_checkbox()
      end, { buffer = true, desc = 'Toggle checkbox' })

      vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<cr>', { desc = 'New Obsidian note' })
      vim.keymap.set('n', '<leader>os', '<cmd>ObsidianSearch<cr>', { desc = 'Search Obsidian notes' })
      vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianToday<cr>', { desc = "Today's daily note" })
    end,
  },
}
