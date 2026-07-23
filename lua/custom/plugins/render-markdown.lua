return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- Render in normal/command mode; show raw source while editing the
      -- current section (insert mode + cursor line).
      render_modes = { 'n', 'c', 't' },
      completions = { lsp = { enabled = true } },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)

      vim.keymap.set('n', '<leader>om', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle Markdown rendering' })
    end,
  },
}
