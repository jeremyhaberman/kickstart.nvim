vim.opt_local.textwidth = 88 -- match ruff-format's line-length; gq wraps comments to 88
vim.opt_local.formatoptions:append 'c' -- auto-wrap comments
vim.opt_local.formatoptions:append 'r' -- continue comments on <Enter>
vim.opt_local.formatoptions:append 'o' -- continue comments on 'o' or 'O'
