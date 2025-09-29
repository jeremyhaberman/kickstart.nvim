return {
  {
    'hrsh7th/nvim-cmp',
    ft = 'markdown',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },
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
            name = 'personal',
            path = '~/Documents/Knowledge Vault/',
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
