vim.keymap.set('n', '<space>cd', ':cd %:p:h<CR>:pwd<CR>', { desc = "Change working directory to the current file" })

vim.keymap.set('n', '<space>ss', ':mksession! .session.vim<CR>', { desc = "Save Current Session" })
vim.keymap.set('n', '<space>sl', ':source .session.vim<CR>', { desc = "Load Session" })

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
vim.keymap.set('n', '<Space>Q', ':copen<cr>', { silent = false })
vim.keymap.set("n", "<space>x", "<cmd>.lua<CR>")
vim.keymap.set("v", "<space>x", "<cmd>lua<CR>")
vim.keymap.set("n", "<space>X", "<cmd>Redir2Reg .lua<CR>")
vim.keymap.set("v", "<space>X", "<cmd>Redir2Reg lua<CR><esc>")

vim.keymap.set('n', '<space>1', ':Neotree toggle<CR>', { silent = true })
vim.keymap.set('n', '-', ':Oil<CR>', { silent = false })
vim.keymap.set('n', '<space>4', '<cmd>Trouble diagnostics toggle<CR>', { silent = true })
vim.keymap.set('n', '<space>5', '<cmd>Trouble document_diagnostics toggle<CR>', { silent = true })
vim.keymap.set('n', ']w', function() require("trouble").next({ skip_groups = true, jump = true }) end,
  { silent = true, desc = 'Next diagnostic with Trouble' })
vim.keymap.set('n', '[w', function() require("trouble").previous({ skip_groups = true, jump = true }) end,
  { silent = true, desc = 'Next diagnostic with Trouble' })


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
-- vim.keymap.set('c', '<c-f>', '<left>')
-- vim.keymap.set('c', '<c-g>', '<right>')

vim.keymap.set('c', 'w!!', 'w !sudo tee % >/dev/null')

-- }}}

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<Space>r', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<Space>R', '<cmd>Telescope grep_string<CR>')
vim.keymap.set('n', '<Space>h', require('telescope.builtin').builtin, { desc = "Built-in" })
vim.keymap.set('n', '<Space>fh', '<cmd>Telescope help_tags<CR>')
vim.keymap.set('n', '<Space>fd', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<Space>fg', '<cmd>Telescope git_files<CR>')
vim.keymap.set('n', '<Space><c-F>', '<cmd>Telescope git_status<CR>')
vim.keymap.set('n', '<Space>fr', '<cmd>Telescope oldfiles<CR>')
vim.keymap.set('n', '<Space>mn', function() require('telescope.builtin').keymaps { modes = { 'n' } } end,
  { desc = "Keymaps N" })
vim.keymap.set('n', '<Space>mx', function() require('telescope.builtin').keymaps { modes = { 'x' } } end,
  { desc = "Keymaps X" })
vim.keymap.set('n', '<Space>mi', function() require('telescope.builtin').keymaps { modes = { 'i' } } end,
  { desc = "Keymaps I" })
vim.keymap.set('n', '<Space>mo', function() require('telescope.builtin').keymaps { modes = { 'o' } } end,
  { desc = "Keymaps O" })
vim.keymap.set('n', '<Space>mt', function() require('telescope.builtin').keymaps { modes = { 't' } } end,
  { desc = "Keymaps T" })
vim.keymap.set('n', '<Space>en', function()
    local opts = require('telescope.themes').get_ivy({ cwd = vim.fn.stdpath('config') })
    require('telescope.builtin').find_files(opts)
  end,
  { desc = "Edit neovim config" })
vim.keymap.set('n', '<Space>fb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<Space>fp', '<cmd>Telescope projects<CR>')
vim.keymap.set('n', '<Space>o', '<cmd>OverseerToggle<CR>')
vim.keymap.set('n', '<Space>a', '<cmd>ToggleTerm<CR>')
vim.keymap.set('n', '<Space>A', '<cmd>TermSelect<CR>')
vim.keymap.set('n', '\\c', '<cmd>Telescope colorscheme<CR>')
vim.keymap.set('n', 'ga.', '<cmd>Telescope textcase<CR>')
vim.keymap.set('v', 'ga.', "<cmd>Telescope textcase<CR>")


vim.keymap.set("n", "<space>L", require('utils').toggle_diagnostic_text, { desc = "Toggle lsp_lines" })
vim.keymap.set("n", "<space>dl", require('utils').toggle_diagnostics_current_buffer,
  { desc = "Toggle diagnostics in current buffer" })

vim.keymap.set('n', 'md', require('remedybg').run_debugger, { silent = true })
vim.keymap.set('n', '<space>ds', require('remedybg').stop_debug, { silent = true })
vim.keymap.set('n', '<space>dr', require('remedybg').start_debug, { silent = true })
vim.keymap.set('n', '<space>db', require('remedybg').toggle_breakpoint, { silent = true })
