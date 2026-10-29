# Neovim cheatsheet

The keys and commands this config sets up. `<leader>` is the space bar.

## Finding a key you forgot

| Key or command | What it does |
|---|---|
| `<leader>?` | Open this cheatsheet in a split |
| Press `<leader>` and wait | which-key lists every leader key |
| `<leader>sk` | Search all keymaps |
| `<leader>sh` | Search Neovim help |
| `g?` | Show the keys for the current Diffview window |
| `:Lazy` | Manage plugins (`:Lazy update` updates them) |
| `:checkhealth` | Diagnose problems with the config |

## Files and search

| Key | What it does |
|---|---|
| `\` | Show the current file in the Neo-tree file explorer. Press `\` again to close it. |
| `<leader>sf` | Find files by name |
| `<leader>sg` | Search file contents (live grep) |
| `<leader>sw` | Search for the word under the cursor |
| `<leader>/` | Fuzzy search in the current file |
| `<leader>s/` | Search in open files |
| `<leader>s.` | Recent files |
| `<leader><leader>` | Open buffers |
| `<leader>sd` | Diagnostics (errors and warnings) |
| `<leader>sr` | Reopen the last search |
| `<leader>sn` | Search this Neovim config |
| `<leader>fp` | Copy the current file's full path |
| `<leader>sp` | Find files in this branch's plan workspace, which can live outside the repo. `<C-v>` opens the result in a split beside your code. |
| `<leader>wp` | Open this branch's plan workspace in its own tab, with Neo-tree. If that tab is already open, switch to it. `gt` moves between tabs. |

## Buffers and windows

| Key | What it does |
|---|---|
| `<S-h>` / `<S-l>` | Previous or next buffer |
| `<leader>bd` | Close the current buffer and keep the window |
| `<C-h/j/k/l>` | Move to the window or tmux pane in that direction |
| `<leader>wc` | Close the window |
| `<leader>wo` | Close all other windows |
| `<leader>w` + arrow key | Resize the window |
| `<Esc><Esc>` | Leave terminal mode |

## Tabs

These keys are built into Neovim. They are here because Diffview and `<leader>wp` open their own tabs.

| Key or command | What it does |
|---|---|
| `:tabnew` | Open an empty tab. `:tabnew path/to/file` opens a file in it. |
| `:tab split` | Open the current buffer in a new tab |
| `<C-w>T` | Move the current window into its own tab |
| `gt` / `gT` | Next or previous tab |
| `3gt` | Go to tab 3 |
| `:tabclose` | Close the tab. Its buffers stay open. |
| `:tabonly` | Close all other tabs |

## Code navigation (LSP)

These keys work in any file that has a language server.

| Key | What it does |
|---|---|
| `gd` | Go to definition |
| `grd` | Go to definition, in a Telescope list |
| `grr` | Find references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grD` | Go to declaration |
| `K` | Show documentation for the symbol under the cursor |
| `gO` | Symbols in this file |
| `gW` | Symbols in the whole project |
| `grn` | Rename the symbol everywhere |
| `gra` | Code actions (quick fixes) |
| `<C-o>` / `<C-i>` | Jump back or forward after a jump |
| `<leader>q` | Put diagnostics in the location list |
| `<leader>th` | Turn inlay hints on or off |

## Completion

Most file types use blink.cmp:

| Key | What it does |
|---|---|
| `<C-n>` / `<C-p>` | Next or previous suggestion |
| `<C-y>` | Accept the suggestion |
| `<C-e>` | Close the menu |
| `<C-Space>` | Open the menu, or show documentation |
| `<C-k>` | Show the function signature |

Markdown uses nvim-cmp instead. There, `<Tab>` and `<S-Tab>` move through suggestions and `<CR>` accepts one.

## Editing and formatting

| Key | What it does |
|---|---|
| `<leader>f` | Format the file (Ruff for Python, stylua for Lua) |
| `gq` + motion | Wrap lines to the file type's width: 100 for Markdown, 88 for Python comments |
| `]m` / `[m` | Next or previous misspelled word |
| `<Esc>` | Clear search highlighting |

## Git

**Fugitive**

| Key or command | What it does |
|---|---|
| `<leader>g` | Open the Git status window (`:Git`) |
| `<leader>gc` | Fetch, then list every change on this branch against `origin/main` in the quickfix list |
| `:Gvdiffsplit` | Diff the current file against the index, side by side |
| `:Git blame` | Blame the whole file |

**Gitsigns hunks.** A hunk is one block of changed lines.

| Key | What it does |
|---|---|
| `]c` / `[c` | Next or previous hunk. In diff mode, this jumps to the next or previous change. |
| `]s` / `[s` | Next or previous staged hunk |
| `]u` / `[u` | Next or previous unstaged hunk |
| `<leader>hp` | Preview the hunk |
| `<leader>hs` / `<leader>hr` | Stage or reset the hunk (works on a selection too) |
| `<leader>hS` / `<leader>hR` | Stage or reset the whole file |
| `<leader>hb` | Blame the current line |
| `<leader>hd` | Diff against the index |
| `<leader>hD` | Diff against the last commit |
| `<leader>tb` | Turn inline blame on or off |
| `<leader>tD` | Show deleted lines inline |

## Reviewing a pull request

You get the PR's full diff and working code navigation in one place.

1. Check the PR out in its own worktree, so your current work stays as it is:

   ```bash
   git fetch origin
   git worktree add ../review-1234 origin/feature/some-branch
   cd ../review-1234 && nvim
   ```

2. Open the full diff: `:DiffviewOpen origin/main...HEAD`. The three dots compare against the merge base, which matches the Files tab in Azure DevOps.
3. Mark the PR's changes in every file you open: `:ReviewBase`. To use another target branch, name it: `:ReviewBase origin/develop`.
4. Review. The right-hand side of each diff is the real file, so `gd`, `grr` and `K` work there. Press `gf` to open a file in a normal window and explore from there. The gutter still marks the PR's changes.
5. Finish: `:DiffviewClose`, then `:ReviewBaseReset`. Remove the worktree with `git worktree remove ../review-1234`.

Leave comments in the Azure DevOps web UI, or ask Claude Code to post them.

To review without Diffview, run `:Git difftool -y origin/main...`, which opens one tab per changed file. Or press `<leader>gc` to get the changes in the quickfix list and step through them with `]q` and `[q`.

## Diffview

| Key | What it does |
|---|---|
| `<Tab>` / `<S-Tab>` | Next or previous file |
| `[F` / `]F` | First or last file |
| `]c` / `[c` | Next or previous change in the file |
| `gf` | Open the file in a normal window |
| `<C-w><C-f>` | Open the file in a split |
| `<C-w>gf` | Open the file in a new tab |
| `<leader>e` | Move to the file panel |
| `<leader>b` | Hide or show the file panel |
| `i` | In the file panel, switch between a list and a folder tree |
| `g<C-x>` | Switch between side-by-side and stacked layouts |
| `g?` | Show all Diffview keys |

| Command | What it does |
|---|---|
| `:DiffviewOpen origin/main...HEAD` | Diff this branch against main |
| `:DiffviewFileHistory --range=origin/main...HEAD` | Step through the branch's commits one at a time |
| `:DiffviewFileHistory %` | Every commit that touched the current file |
| `:DiffviewClose` | Close Diffview |

Avoid these keys in a review, because they change files on disk:
- `X` replaces the file with the target branch's version.
- `s`, `-`, `S` and `U` stage or unstage files.

## Markdown

| Key | What it does |
|---|---|
| `<leader>mc` | Toggle a checkbox |
| `<leader>mp` | Open or close the live preview in the browser |
| `<leader>om` | Turn rendered Markdown on or off in the editor |
