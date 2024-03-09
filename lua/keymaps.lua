vim.keymap.set('n', '<space>cd', ':cd %:p:h<CR>:pwd<CR>')
vim.keymap.set('n', '<space>sv', ':source $MYVIMRC<CR>')
vim.keymap.set('n', '<Space>ev', ':e  $MYVIMRC<CR>')
vim.keymap.set('n', '<Space>eev', ':vsplit  $MYVIMRC<CR>')
vim.keymap.set('n', '<C-L>', ':nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:sign unplace *<cr><c-l>',
  { silent = true })
vim.keymap.set({ 'n', 'i' }, '<C-PageDown>', '<cmd>cnext<cr>', { silent = true })
vim.keymap.set({ 'n', 'i' }, '<C-PageUp>', '<cmd>cprevious<cr>', { silent = true })

vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { expr = true })

vim.keymap.set('', '<space><bs>', ':bprevious|bdelete #<CR>', { silent = true })
vim.keymap.set('', '<space><space><bs>', ':bdelete!<CR>', { silent = true })
vim.keymap.set('n', '<space>w', ':w<CR>', { silent = false })

vim.keymap.set('n', '<Space>z', 'zMzvzz', { silent = false })
vim.keymap.set('n', '<Space>8', ':let @/=\'\\<<C-R>=expand("<cword>")<CR>\\>\'<CR>:set hls<CR>', { silent = true })

-- " copy & paste {{{
vim.keymap.set('v', '<space>y', '"+y', { remap = true })
vim.keymap.set({ 'n', 'v' }, '<space>p', '"+p', { remap = true })
vim.keymap.set({ 'n', 'v' }, '<space>P', '"+P', { remap = true })
-- " }}}

vim.keymap.set('n', 'n', 'nzzzv', { silent = false })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = false })

vim.keymap.set('n', '<Space>q', ':cclose<bar>lclose<cr>', { silent = false })

vim.keymap.set('n', '<space>1', ':Neotree toggle<CR>', { silent = true })
vim.keymap.set('n', '<space>2', ':Oil<CR>', { silent = true })
vim.keymap.set('n', '<space>4', ':TroubleToggle workspace_diagnostics<CR>', { silent = true })
vim.keymap.set('n', '<space>5', ':TroubleToggle document_diagnostics<CR>', { silent = true })
vim.keymap.set('n', ']w', '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>', { silent = true })
vim.keymap.set('n', '[w', '<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>',
  { silent = true })


-- fallback if LSP does not support {{{
vim.keymap.set('n', '<space>sf', ':FSHere<CR>')
vim.keymap.set('n', '<space>=', ':keepjumps normal mzgg=Gg`zzz<CR>')
-- }}}


-- Command-line mappings {{{

-- " Bash like keys for the command line. These resemble personal zsh mappings
vim.keymap.set('c', '<c-a>', '<home>')
vim.keymap.set('c', '<c-e>', '<end>')

-- " Ctrl-[hl]: Move left/right by word
vim.keymap.set('c', '<c-h>', '<s-left>')
vim.keymap.set('c', '<c-l>', '<s-right>')

-- " Ctrl-space: Show history
vim.keymap.set('c', '<c-@>', '<c-f>')

vim.keymap.set('c', '<c-j>', '<down>')
vim.keymap.set('c', '<c-k>', '<up>')
vim.keymap.set('c', '<c-f>', '<left>')
vim.keymap.set('c', '<c-g>', '<right>')

vim.keymap.set('c', 'w!!', 'w !sudo tee % >/dev/null')

-- }}}
-- completion {{{

-- }}}
