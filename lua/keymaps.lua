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


-- fallback if LSP does not support {{{
vim.keymap.set('n', '<space>sf', ':FSHere<CR>')
-- vim.keymap.set('n', '<space>=', ':keepjumps normal mzgg=Gg`zzz<CR>')
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
vim.keymap.set('n', '<Space>fH', '<cmd>Telescope help_tags <CWORD><CR>')
vim.keymap.set('n', '<Space>fH',
  function() require('telescope.builtin').help_tags({ default_text = vim.fn.expand("<cword>") }) end,
  { desc = "Help tag" })
vim.keymap.set('n', '<Space>fd', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<Space>fD', function()
    require('telescope.builtin').find_files({
      cwd = vim.g.build_dir,
      find_command = { "rg", "-u", "--files", "--hidden", "--follow", "--glob", "!.git/*" },
    })
  end,
  { desc = "Find files in the build directory" })
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
    require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })
  end,
  { desc = "Edit neovim config" })
vim.keymap.set('n', '<Space>ep', function()
    require('telescope.builtin').find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath('data'), "lazy") })
  end,
  { desc = "Edit neovim plugin" })
vim.keymap.set('n', '<Space>fb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<Space>fp', '<cmd>Telescope projects<CR>')
vim.keymap.set('n', '<Space>o', '<cmd>OverseerToggle<CR>')
vim.keymap.set('n', '<Space>O', '<cmd>OverseerQuickAction open float<CR>')
-- vim.keymap.set('n', '<Space>a', '<cmd>ToggleTerm<CR>')
vim.keymap.set('n', '<Space>A', '<cmd>TermSelect<CR>')
vim.keymap.set('n', '\\c', '<cmd>Telescope colorscheme<CR>')
vim.keymap.set('n', 'ga.', '<cmd>Telescope textcase<CR>')
vim.keymap.set('v', 'ga.', "<cmd>Telescope textcase<CR>")

vim.keymap.set('n', '<Space>ff', require('telescope.builtin').resume, { desc = "Resume last telescope" })
vim.keymap.set('n', '<Space>fF', require('telescope.builtin').pickers, { desc = "List all telescope pickers" })
vim.keymap.set('n', '<Space>j', require('telescope.builtin').jumplist, { desc = "Show jumplist" })

vim.keymap.set('n', '<Space>ul', '<cmd>Lazy update<cr>')
-- vim.keymap.set("n", "<space>L", require('utils').toggle_diagnostic_text, { desc = "Toggle lsp_lines" })
vim.keymap.set("n", "<space>dl", require('utils').toggle_diagnostics_current_buffer,
  { desc = "Toggle diagnostics in current buffer" })

vim.keymap.set('n', '<space>md', require('remedybg').run_debugger, { silent = true })
vim.keymap.set('n', '<space>ds', require('remedybg').stop_debug, { silent = true })
vim.keymap.set('n', '<space>dr', require('remedybg').start_debug, { silent = true })
vim.keymap.set('n', '<space>db', require('remedybg').toggle_breakpoint, { silent = true })

vim.keymap.set('n', '<space>ma', require('cmake_configuration').compile_current_file,
  { silent = true, desc = "Compile current file" })
vim.keymap.set('n', '<space>mm', ':wa | CMake build<CR>', { silent = true })
vim.keymap.set('n', '<space>mc', ':CMake build --target clean<CR>', { silent = true })
vim.keymap.set('n', '<space>mC', ':CMake configure<CR>', { silent = true })
vim.keymap.set('n', '<space>ms', require('cmake_configuration').pick_cmake_configuration,
  { noremap = true, silent = true })

vim.keymap.set('n', '<space>me',
  function()
    require('cmake_configuration').pick_executable(
      {
        on_selection = function(item)
          require("remedybg").start_debugging(vim.g.build_dir, item)
        end
      })
  end,
  { noremap = true, silent = true })

vim.keymap.set('n', '<space>mt', function()
    require("overseer").run_template({ name = "Run CTest", params = { working_dir = vim.g.build_dir, } })
  end,
  { noremap = true, silent = true })
