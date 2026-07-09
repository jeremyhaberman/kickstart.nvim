-- Live, scroll-synced Markdown preview in the browser (renders Mermaid, KaTeX, tables, etc.)
-- Workflow: tile WezTerm on one half of the screen, the browser on the other, and edit side-by-side.
return {
  {
    'iamcco/markdown-preview.nvim',
    -- Only load for markdown, and only when the preview commands/keys are used.
    ft = { 'markdown' },
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    -- One-time build of the preview server assets.
    -- Prefer building from source with npx (avoids the E117 autoload chicken-and-egg);
    -- otherwise force-load the plugin so its autoload function exists, then install.
    build = function(plugin)
      if vim.fn.executable 'npx' == 1 then
        vim.cmd('!cd ' .. plugin.dir .. ' && cd app && npx --yes yarn install')
      else
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn['mkdp#util#install']()
      end
    end,
    config = function()
      -- Keep the preview open when you jump to another buffer, so it survives
      -- normal side-by-side editing instead of slamming shut on every switch.
      vim.g.mkdp_auto_close = 0
      -- Match the browser preview to your Atom Dark editor theme.
      vim.g.mkdp_theme = 'dark'
      -- Print the preview URL when it opens (handy if the browser doesn't auto-focus).
      vim.g.mkdp_echo_preview_url = 1
    end,
    -- The lazy.nvim `keys` field both defines the mapping AND lazy-loads the
    -- plugin the moment you press it.
    keys = {
      -- TODO(human): add a keymap that toggles the preview.
      -- Shape of one entry:
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', ft = 'markdown', desc = '...' },
      -- The `<leader>m` group is already registered in init.lua as [M]arkdown.
    },
  },
}
