vim.keymap.set('n', '<space>cd', ':cd %:p:h<CR>:pwd<CR>', { desc = "Change working directory to the current file" })

vim.keymap.set('n', '<space>ss', require('utils').save_session, { desc = "Save Current Session" })
vim.keymap.set('n', '<space>sl', require('utils').load_session, { desc = "Load Session" })

vim.keymap.set('n', '\\q',
  function()
    require('utils').save_session()
    vim.cmd.restart({ args = { "lua", "require('utils').load_session()" } })
  end, { desc = 'Restart Neovim with session' })

vim.keymap.set('n', '\\Q', function() vim.cmd.restart() end, { desc = 'Restart Neovim without session' })

vim.keymap.set('n', '<C-L>', ':nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:sign unplace *<cr><c-l>',
  { silent = true })
vim.keymap.set({ 'n', 'i' }, '<C-PageDown>', '<cmd>cnext<cr>', { silent = true })
vim.keymap.set({ 'n', 'i' }, '<C-PageUp>', '<cmd>cprevious<cr>', { silent = true })

-- Quickly go to the end of the line while in insert mode.
vim.keymap.set({ 'i', 'c' }, '<C-l>', '<C-o>A', { desc = 'Go to the end of the line' })

vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { expr = true })

-- Indent while remaining in visual mode.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('', '<space><bs>', ':bprevious|bdelete #<CR>', { silent = true })
vim.keymap.set('', '<space><space><bs>', ':bdelete!<CR>', { silent = true })

vim.keymap.set('n', '<Space>z', 'zMzvzz', { silent = false })
vim.keymap.set('n', '<Space>8', ':let @/=\'\\<<C-R>=expand("<cword>")<CR>\\>\'<CR>:set hls<CR>', { silent = true })


vim.keymap.set('n', 'n', 'nzzzv', { silent = false })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = false })

vim.keymap.set('n', '<Space>q', ':cclose<bar>lclose<cr>', { silent = false })
vim.keymap.set('n', '<Space>Q', ':copen<cr>', { silent = false })
-- vim.keymap.set("n", "<space>x", "<cmd>.lua<CR>")
-- vim.keymap.set("v", "<space>x", "<cmd>lua<CR>")
-- vim.keymap.set("n", "<space>X", "<cmd>Redir2Reg .lua<CR>")
-- vim.keymap.set("v", "<space>X", "<cmd>Redir2Reg lua<CR><esc>")

vim.keymap.set('n', '<space>1', ':Neotree toggle<CR>', { silent = true })
vim.keymap.set('n', '-', ':Oil<CR>', { silent = false })


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

vim.keymap.set('c', 'w!!', 'w !sudo tee % >/dev/null')

-- }}}

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<Space>r', function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set({ 'n', 'x' }, '<Space>R', function() Snacks.picker.grep_word() end, { desc = "Grep word" })
vim.keymap.set('n', '<Space>h', function() Snacks.picker() end, { desc = "Built-in" })
vim.keymap.set('n', '<Space>fh', function() Snacks.picker.help() end, { desc = "Help tags" })
vim.keymap.set('n', '<Space>fH',
  function()
    Snacks.picker.help({ search = function(picker) return picker:word() end, })
  end,
  { desc = "Help tags (current)" })
vim.keymap.set('n', '<Space>fd', function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set('n', '<Space>fD', function() Snacks.picker.files({ dirs = { vim.g.build_dir } }) end,
  { desc = "Find files in build directory" })
vim.keymap.set('n', '<Space>en', function() Snacks.picker.files({ dirs = { vim.fn.stdpath('config') } }) end,
  { desc = "Find files in the config directory" })
vim.keymap.set('n', '<Space>ep',
  function() Snacks.picker.files({ dirs = { vim.fs.joinpath(vim.fn.stdpath('data'), "lazy") } }) end,
  { desc = "Find files in the plugin directory" })
vim.keymap.set('n', '<Space>fg', function() Snacks.picker.git_files() end, { desc = "Find git files" })
vim.keymap.set('n', '<Space>fr', function() Snacks.picker.recent() end, { desc = "Find recent files" })
vim.keymap.set('n', '<Space>mn', function() Snacks.picker.keymaps({ modes = { 'n' } }) end, { desc = "Keymaps N" })
vim.keymap.set('n', '<Space>mx', function() Snacks.picker.keymaps({ modes = { 'x' } }) end, { desc = "Keymaps X" })
vim.keymap.set('n', '<Space>mv', function() Snacks.picker.keymaps({ modes = { 'v' } }) end, { desc = "Keymaps V" })
vim.keymap.set('n', '<Space>mi', function() Snacks.picker.keymaps({ modes = { 'i' } }) end, { desc = "Keymaps I" })
vim.keymap.set('n', '<Space>mo', function() Snacks.picker.keymaps({ modes = { 'o' } }) end, { desc = "Keymaps O" })
vim.keymap.set('n', '<Space>mt', function() Snacks.picker.keymaps({ modes = { 't' } }) end, { desc = "Keymaps T" })
vim.keymap.set('n', '<Space>fb', function() Snacks.picker.buffers() end, { desc = "Find buffers" })
vim.keymap.set('n', '<Space>fB', function() Snacks.picker.grep_buffers() end, { desc = "Grep buffers" })
vim.keymap.set('n', '<Space>ff', function() Snacks.picker.resume() end, { desc = "Resume last picker" })
vim.keymap.set('n', '<Space>j', function() Snacks.picker.jumps() end, { desc = "Show jumplist" })
vim.keymap.set('n', '\\c', function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
vim.keymap.set('n', '<Space>o', '<cmd>OverseerToggle<CR>')
vim.keymap.set('n', '<Space>O', '<cmd>OverseerQuickAction open float<CR>')
vim.keymap.set('n', '<Space>A', '<cmd>TermSelect<CR>')
vim.keymap.set('n', 'ga.', '<cmd>Telescope textcase<CR>')
vim.keymap.set('v', 'ga.', "<cmd>Telescope textcase<CR>")


vim.keymap.set('n', '<Space>ul', '<cmd>Lazy update<cr>')
vim.keymap.set("n", "<space>dl", require('utils').toggle_diagnostics_current_buffer,
  { desc = "Toggle diagnostics in current buffer" })


vim.keymap.set('n', '<space>ma', require('cmake_configuration').compile_current_file,
  { silent = true, desc = "Compile current file" })
vim.keymap.set('n', '<space>mm', ':wa | CMake build<CR>', { silent = true })
vim.keymap.set('n', '<space>mc', ':CMake build --target clean<CR>', { silent = true })
vim.keymap.set('n', '<space>mC', ':CMake configure<CR>', { silent = true })
vim.keymap.set('n', '<space>ms', require('cmake_configuration').pick_cmake_configuration,
  { noremap = true, silent = true })

vim.keymap.set('n', '<space>ds', require('remedybg').stop_debug, { silent = true })
vim.keymap.set('n', '<space>dr', require('remedybg').start_debug, { silent = true })
vim.keymap.set('n', '<space>db', require('remedybg').toggle_breakpoint, { silent = true })
vim.keymap.set('n', '<space>dR', require('remedybg').run_debugger, { silent = true })
vim.keymap.set('n', '<space>de',
  function()
    require('cmake_configuration').pick_executable(
      {
        on_selection = function(item)
          require("remedybg").start_debugging(vim.g.build_dir,
            {
              executable = item.executable,
              target_name = item.target_name
            })
        end
      })
  end,
  { noremap = true, silent = true })

vim.keymap.set('n', '<space>dt', function()
    require("overseer").run_task({ name = "Run CTest", params = { working_dir = vim.g.build_dir, } })
  end,
  { noremap = true, silent = true })

vim.keymap.set('n', '<space>dd', vim.diagnostic.setqflist, { silent = true, desc = 'Send diagnostics to quickfix list' })
