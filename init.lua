vim.loader.enable()
vim.opt.termguicolors = true

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_command('filetype on')
-- vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/parsers/")

-- NOTE: for vim-unimpaired
vim.g.nremap = { ['<p'] = '', ['>p'] = '', ['<P'] = '', ['>P'] = '' }
vim.g.mapleader = "<Space>"
vim.g.maplocalleader = "\\"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_augroup("GoToLastPosition", { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufReadPost' }, {
  group = "GoToLastPosition",
  pattern = "*",
  callback = function()
    local row, column = unpack(vim.api.nvim_buf_get_mark(0, '"'))
    local buf_line_count = vim.api.nvim_buf_line_count(0)

    if row >= 1 and row <= buf_line_count then
      vim.api.nvim_win_set_cursor(0, { row, column })
    end
  end,
})

require('packages').install()

require('colors').setup_colors()

-- When switching buffers, preserve window view. {{{
vim.api.nvim_create_augroup("SaveWindowGroup", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
  group = "SaveWindowGroup",
  pattern = "*",
  callback = require('utils').auto_save_win_view
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = "SaveWindowGroup",
  pattern = "*",
  callback = require('utils').auto_restore_win_view
})
-- vim.api.nvim_create_augroup("SaveWindowGroup", { clear = true })
-- }}}

vim.opt.showcmd    = true
vim.opt.showmatch  = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true
vim.opt.incsearch  = true
vim.opt.inccommand = "nosplit"
vim.opt.autowrite  = true
vim.opt.hidden     = true
vim.opt.mouse      = "a"
vim.opt.hlsearch   = true
vim.opt.history    = 10000
vim.opt.undolevels = 1000

vim.opt.wildignore:append { "*.swp", "*.bak", "*.pyc", "*.class" }
vim.opt.wildignore:append { "*/tmp/*", "*.so", "*.swp", "*.zip", "*.d", "*.o" }
vim.opt.wildignore:append { "*\\tmp\\*", "*.swp", "*.zip", "*.exe" }
vim.opt.wildignore:append { "*.doc", "*.docx", "*.pdf", "*.ppt", "*.pptx", "*.xls", "*.wmv" }
vim.opt.wildignore:append { "*.bbl", "*.synctex.gz", "*.blg", "*.aux" }
vim.opt.wildignore:append { "*\\vendor\\**" }
vim.opt.wildignore:append { "*/vendor/**" }

vim.opt.wildignorecase = true
vim.opt.wildmode = { "longest", "full" }
vim.opt.title = true
vim.opt.undofile = true
vim.opt.showmode = true
vim.opt.wildoptions:append { "pum" }
vim.opt.wildmenu = true
vim.opt.laststatus = 2
vim.opt.scrolloff = 5
vim.opt.shortmess = "aOstT"
vim.opt.sidescrolloff = 5
vim.opt.shiftround = true
vim.opt.report = 0
vim.opt.shiftround = true
vim.opt.list = true
vim.opt.listchars = { trail = "•", tab = "»·" }
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
}

vim.opt.breakindent = true
vim.opt.breakindentopt:append { "sbr" }

vim.opt.tags:append { "tags", "./tags", "~/.vimtags" }
vim.opt.completeopt = { "menu", "preview", "noselect", "menuone" }

vim.opt.cmdheight = 2

vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 200

vim.opt.startofline = false

local data_dir = vim.fn.stdpath('data')
vim.opt.backupdir = data_dir .. '/backup'
vim.opt.undodir = data_dir .. '/undo'
vim.opt.directory = data_dir .. '/swap'

-- if vim.fn.isdirectory(vim.fn.expand(vim.opt.backupdir)) ~=0 then
-- vim.fn.mkdir(vim.fn.expand(vim.opt.backupdir), "p")
-- end
-- if vim.fn.isdirectory(vim.opt.undodir) ~=0 then
-- vim.fn.mkdir(vim.opt.undodir, "p")
-- end
-- if vim.fn.isdirectory(vim.opt.directory) ~=0 then
-- vim.fn.mkdir(vim.opt.directory, "p")
-- end


vim.opt.colorcolumn = "+1"
-- " Highlight VCS conflict markers
-- match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

vim.opt.sps = { "best", 10 }
vim.opt.spelllang = { "en", "pl" }

vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.api.nvim_set_hl(0, "CursorLineNr", { link = "CursorLine" })

-- " Number line settings {{{
local number_lines_id = vim.api.nvim_create_augroup("NumberLines", { clear = true })
local set_norelativenumbers = function() vim.opt.relativenumber = false end
local set_relativenumbers = function()
  if vim.bo.filetype == 'NvimTree'
      or vim.bo.filetype == 'help'
      or vim.bo.filetype == 'undotree'
      or vim.bo.filetype == 'vista_kind'
      or vim.bo.filetype == 'neo-tree'
  then
    vim.opt.relativenumber = false
  else
    vim.opt.relativenumber = true
  end
end
vim.api.nvim_create_autocmd("FocusLost",
  {
    group = number_lines_id, pattern = "*", callback = set_norelativenumbers
  })
vim.api.nvim_create_autocmd("WinLeave",
  {
    group = number_lines_id, pattern = "*", callback = set_norelativenumbers
  })
vim.api.nvim_create_autocmd("InsertEnter",
  {
    group = number_lines_id, pattern = "*", callback = set_norelativenumbers
  })
vim.api.nvim_create_autocmd("FocusGained",
  {
    group = number_lines_id, pattern = "*", callback = set_relativenumbers
  })
vim.api.nvim_create_autocmd("WinEnter",
  {
    group = number_lines_id, pattern = "*", callback = set_relativenumbers
  })
vim.api.nvim_create_autocmd("InsertLeave",
  {
    group = number_lines_id, pattern = "*", callback = set_relativenumbers
  })
-- " }}}

local make_directory_on_save_id = vim.api.nvim_create_augroup("MakeDirectoryOnSave", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" },
  {
    group = make_directory_on_save_id,
    pattern = "*",
    callback = function(event)
      if vim.bo[event.buf].filetype == 'oil' then
        return
      end
      local file = vim.loop.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
  })

vim.opt.switchbuf = "useopen"
vim.opt.showtabline = 1
vim.opt.tabpagemax = 15
vim.api.nvim_command("command! -nargs=+ -complete=file_in_path -bar Grep silent! grep! <args> | redraw!")

vim.opt.grepprg = "rg --vimgrep"

vim.keymap.set('n', '<space>cw', ':setlocal invwrap<CR>')
vim.keymap.set('n', '<space>cd', ':cd %:p:h<CR>:pwd<CR>')
vim.keymap.set('n', '<space>sv', ':source $MYVIMRC<CR>')
vim.keymap.set('n', '<Space>ev', ':e  $MYVIMRC<CR>')
vim.keymap.set('n', '<Space>eev', ':vsplit  $MYVIMRC<CR>')
vim.keymap.set('n', '<Space>l', ':s/\\.\\ /\\.\\r/g<CR>:nohl<CR>')
vim.keymap.set('n', '<C-L>',
  ':nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:sign unplace *<cr><c-l>',
  { silent = true })
-- vim.keymap.set('n', 'mm', ':Task start auto build<CR>', { silent = true })
-- vim.keymap.set('n', 'mc', ':Task start auto clean<CR>', { silent = true })
-- vim.keymap.set('n', 'mC', ':Task start auto configure<CR>', { silent = true })
-- vim.keymap.set('n', 'mc', ':Make "%:p^"<CR>', { silent = true })
vim.keymap.set('n', 'mt', ':Make check<CR>', { silent = true })

vim.keymap.set({ 'n', 'i' }, '<C-PageDown>', '<Plug>(unimpaired-cnext)', { silent = true })
vim.keymap.set({ 'n', 'i' }, '<C-PageUp>', '<Plug>(unimpaired-cprevious)', { silent = true })

-- " reindent
-- vim.keymap.set('n', '<space>=', ':keepjumps normal mzgg=Gg`zzz<CR>')
vim.keymap.set('n', '<space>sf', ':FSHere<CR>')

vim.cmd [[
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
" nmap        s   <Plug>(vsnip-select-text)
" xmap        s   <Plug>(vsnip-select-text)
" nmap        S   <Plug>(vsnip-cut-text)
" xmap        S   <Plug>(vsnip-cut-text)
]]

-- "===============================================================================
-- " Command-line Mode Key Mappings
-- "===============================================================================

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

vim.keymap.set('', '<space><bs>', ':bprevious|bdelete #<CR>', { silent = true })
vim.keymap.set('', '<space><space><bs>', ':bdelete!<CR>', { silent = true })
-- vim.keymap.set('n', '<space>1', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<space>1', ':Neotree toggle<CR>', { silent = true })
vim.keymap.set('n', '<space>2', ':Oil<CR>', { silent = true })
vim.keymap.set('n', '<space>4', ':TroubleToggle workspace_diagnostics<CR>', { silent = true })
vim.keymap.set('n', '<space>5', ':TroubleToggle document_diagnostics<CR>', { silent = true })
vim.keymap.set('n', ']w', '<cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>', { silent = true })
vim.keymap.set('n', '[w', '<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>',
  { silent = true })
-- vim.keymap.set('n', '<space>3', ':UndotreeToggle<CR>', { silent = true })
-- vim.keymap.set('n', '<F12>', ':set invpaste paste?<CR>', { silent = false })
-- vim.keymap.set('i', '<F12>', '<C-O>:set invpaste paste?<CR>', { silent = false })
-- vim.keymap.set("n", "<leader>xx", ":TroubleToggle<cr>",
-- {silent = true, noremap = true}
-- )
-- vim.keymap.set("n", "<leader>xw", ":TroubleToggle workspace_diagnostics<cr>",
-- {silent = true, noremap = true}
-- )
-- vim.keymap.set("n", "<leader>xd", ":TroubleToggle document_diagnostics<cr>",
-- {silent = true, noremap = true}
-- )
-- vim.keymap.set("n", "<leader>xl", ":TroubleToggle loclist<cr>",
-- {silent = true, noremap = true}
-- )
-- vim.keymap.set("n", "<leader>xq", ":TroubleToggle quickfix<cr>",
-- {silent = true, noremap = true}
-- )
-- vim.keymap.set("n", "gR", ":TroubleToggle lsp_references<cr>",
-- {silent = true, noremap = true}
-- )
vim.keymap.set('n', '<Space>z', 'zMzvzz', { silent = false })
vim.keymap.set('n', '<Space>ss', 'O//<esc>70A-<esc>', { silent = false })

vim.keymap.set('n', '<Space>8', ':let @/=\'\\<<C-R>=expand("<cword>")<CR>\\>\'<CR>:set hls<CR>', { silent = true })

vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { expr = true })

-- " saving file {{{
vim.keymap.set('n', '<space>w', ':w<CR>', { silent = false })
-- " }}}

-- " copy & paste {{{
vim.keymap.set('v', '<space>y', '"+y', { remap = true })
vim.keymap.set({ 'n', 'v' }, '<space>p', '"+p', { remap = true })
vim.keymap.set({ 'n', 'v' }, '<space>P', '"+P', { remap = true })
-- " }}}

-- "===============================================================================
-- " Insert Mode Ctrl Key Mappings
-- "===============================================================================
-- " Ctrl-w: Delete previous word, create undo point
vim.keymap.set('i', '<c-w>', '<c-g>u<c-w>', { silent = false })

-- " Ctrl-u: Delete til beginning of line, create undo point
vim.keymap.set('i', '<c-u>', '<c-g>u<c-u>', { silent = false })

-- "===============================================================================
-- " Normal Mode Key Mappings
-- "===============================================================================
-- "n: Next, keep search matches in the middle of the window

vim.keymap.set('n', 'n', 'nzzzv', { silent = false })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = false })

vim.keymap.set('n', '<Space>q', ':cclose<bar>lclose<cr>', { silent = false })

-- vim.keymap.set('i', '<CR>', function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<C-g>u<CR>" end, { expr = true })

vim.keymap.set('i', '<C-d>', function() return vim.fn.pumvisible() == 1 and "<PageDown>" or "<C-d>" end, { expr = true })
vim.keymap.set('i', '<C-u>', function() return vim.fn.pumvisible() == 1 and "<PageUp>" or "<C-g>u<C-u>" end,
  { expr = true })

-- " Folding ----------------------------------------------------------------- {{{
vim.opt.foldlevelstart = 99
-- " Make zO recursively open whatever top level fold we're in, no matter where the
-- " cursor happens to be.
vim.keymap.set('n', 'zO', 'zCzO', { silent = false })
vim.opt.foldtext = "myfunctions#fold#MyFoldText()"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
-- " }}}

-- " Filetype-specific ------------------------------------------------------- {{{

-- " Shaders {{{
vim.filetype.add({
  extension = {
    glsl = 'glsl',
    hlsl = 'hlsl',
    psh = 'hlsl',
    vsh = 'hlsl',
  }
})
-- }}}
-- " QuickFix {{{

vim.api.nvim_create_augroup("ft_quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_quickfix",
    pattern = "qf",
    callback = function()
      vim.cmd [[wincmd L]]
      -- vim.cmd [[resize 10]]
      vim.cmd [[setlocal colorcolumn=0 nolist nocursorline nowrap tw=0]]
    end
  })
-- " }}}
-- " Vim {{{
vim.api.nvim_create_augroup("ft_vim", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_vim",
    pattern = "vim",
    callback = function()
      vim.opt_local.foldmethod = "marker"
    end
  })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_vim",
    pattern = "help",
    callback = function()
      vim.opt_local.textwidth = 78
    end
  })
vim.api.nvim_create_autocmd("BufWinEnter",
  {
    group = "ft_vim",
    pattern = "*.txt",
    callback = function()
      if vim.bo.filetype == 'help' then
        vim.cmd [[wincmd L]]
      end
    end
  })
-- " }}}

-- " }}}
--
vim.api.nvim_create_user_command("Todo", "call myfunctions#todo#todo()", {})

-- " undotree {{{
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SplitWidth = 33
-- " }}}
-- " nerdcommenter {{{
vim.g.NERDSpaceDelims = 1
vim.g.NERDCreateDefaultMappings = 0

vim.keymap.set({ 'n', 'v' }, '<Space>cc', '<Plug>NERDCommenterComment', { silent = false })
vim.keymap.set({ 'n', 'v' }, '<Space>cu', '<Plug>NERDCommenterUncomment', { silent = false })
-- " }}}


-- " Secure Modelines {{{
vim.g.secure_modelines_allowed_items = {
  "textwidth", "tw",
  "foldmethod", "fdm",
  "foldnextmax", "fdn",
  "foldlevel", "foldlevelstart",
  "spelllang", "ft"
}
-- " }}}
-- " Signify {{{
vim.g.signify_vcs_list = { 'git', 'svn' }
vim.g.signify_mapping_next_hunk = ']c'
vim.g.signify_mapping_prev_hunk = '[c'
vim.keymap.set('n', '<nop>', '<plug>(signify-toggle-highlight)', { remap = true })
vim.keymap.set('n', '<nop>', '<plug>(signify-toggle)', { remap = true })
vim.keymap.set({ 'o', 'x' }, '<nop>', '<plug>(signify-motion-inner-pending)', { remap = true })
vim.keymap.set({ 'o', 'x' }, '<nop>', '<plug>(signify-motion-inner-visual)', { remap = true })
-- " }}}
-- " exrc.nvim {{{
-- disable built-in local config file support
vim.o.exrc = false

-- }}}
-- " Fugitive {{{
-- vim.keymap.set('n', '<Space>gs', ':Git<CR>', { remap = false })
-- vim.keymap.set('n', '<Space>gc', ':Git commit<CR>', { remap = false })
-- vim.keymap.set('n', '<Space>gl', ':Gclog!<CR>', { remap = false })
-- " }}}
-- " fzf {{{
-- "
-- " [Buffers] Jump to the existing window if possible
vim.g.fzf_buffers_jump = 0
vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*" '
vim.env.FZF_DEFAULT_OPTS = '--layout=reverse  --margin=1,2'


vim.g.fzf_colors =
{
  ['fg'] = { 'fg', 'Normal' },
  ['bg'] = { 'bg', 'Normal' },
  ['hl'] = { 'fg', 'Comment' },
  ['fg+'] = { 'fg', 'CursorLine', 'CursorColumn', 'Normal' },
  ['bg+'] = { 'bg', 'CursorLine', 'CursorColumn' },
  ['hl+'] = { 'fg', 'Statement' },
  ['info'] = { 'fg', 'PreProc' },
  ['border'] = { 'fg', 'Ignore' },
  ['prompt'] = { 'fg', 'Conditional' },
  ['pointer'] = { 'fg', 'Exception' },
  ['marker'] = { 'fg', 'Keyword' },
  ['spinner'] = { 'fg', 'Label' },
  ['header'] = { 'fg', 'Comment' }
}

-- " Terminal buffer options for fzf
vim.api.nvim_clear_autocmds({
  event = "FileType",
  pattern = "NvimTree"
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree" },
  callback = function()
    vim.opt.showmode = false
    vim.opt.ruler = false
    vim.opt.number = false
  end
})



vim.g.fzf_files_options = ' --bind alt-a:select-all,alt-d:deselect-all '
-- vim.keymap.set('i', '<c-x><c-f>', '<plug>(fzf-complete-path)', { remap = true })
vim.keymap.set('i', '<c-x><c-f>', ":lua require('cmp').complete({config={sources ={{name='path'}}}})", { remap = true })
vim.keymap.set('i', '<c-x><c-j>', '<plug>(fzf-complete-file-ag)', { remap = true })
vim.keymap.set('i', '<c-x><c-l>', '<plug>(fzf-complete-line)', { remap = true })
vim.g.fzf_action = {
  ['ctrl-q'] = vim.fn['myfunctions#fzf#build_location_list'],
  ['ctrl-t'] = 'tab split',
  ['ctrl-x'] = 'split',
  ['ctrl-v'] = 'vsplit'
}
-- " }}}

-- " Tagbar {{{
vim.g.tagbar_left = 1
vim.g.tagbar_width = 33
vim.g.tagbar_compact = 1
-- " }}}
-- " Vista {{{
vim.g.vista_default_executive = 'nvim_lsp'
vim.g.vista_fzf_preview = { 'right:50%' }
vim.g.vista_sidebar_position = "vertical topleft"
vim.g.vista_sidebar_width = 33
vim.g.tagbar_compact = 1
vim.g.vista_disable_statusline = false
vim.g.vista_echo_cursor_strategy = 'echo'
vim.g.vista_echo_cursor = 1
-- " }}}
--
-- " Vim-notes {{{
vim.g.notes_directories = { '~/Documents/notes' }
-- " }}}
-- " CSV {{{
vim.g.csv_autocmd_arrange = 1
-- " }}}
-- " Gist {{{
vim.g.gist_post_private = 1
vim.g.gist_show_privates = 1
vim.g.gist_detect_filetype = 1
vim.g.gist_open_browser_after_post = 1
-- " }}}
-- " nvim-lsp {{{

-- require 'notifier'.setup {
-- -- You configuration here
-- }

-- Set up nvim-cmp.
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
-- capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
local capabilitiesClangd = vim.deepcopy(capabilities)
capabilitiesClangd.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.set_log_level("ERROR")

require 'lspconfig'.marksman.setup {
  capabilities = capabilities
}
-- require('lspconfig').rls.setup {
-- capabilities = capabilities
-- }
require('lspconfig').rust_analyzer.setup {
  capabilities = capabilities
}
require 'lspconfig'.glslls.setup {
  capabilities = capabilities
}
local clangd_attach_hints = function(client)
  -- require("clangd_extensions.inlay_hints").setup_autocmd()
  -- require("clangd_extensions.inlay_hints").set_inlay_hints()
end

local get_clangd_path = function()
  if vim.fn.has('windows') then
    return 'clangd'
  else
    return "/opt/clang/latest/bin/clangd"
  end
end
local get_clangd_query_driver = function()
  local drivers = {
    "clang-cl.exe",
    "clang++",
    "clang",
    "gcc",
    "g++",
    "arm-none-eabi-g++",
    "arm-none-eabi-gcc",
    os.getenv("ARM_GCC_PATH") .. "arm-none-eabi-g++",
    os.getenv("ARM_GCC_PATH") .. "arm-none-eabi-g++"
  }
  return "--query-driver=" .. table.concat(drivers, ",")
end
local original = vim.lsp.handlers['textDocument/publishDiagnostics']
vim.lsp.handlers['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
  vim.tbl_map(function(item)
    if item.relatedInformation and #item.relatedInformation > 0 then
      vim.tbl_map(function(k)
        if k.location then
          local tail = vim.fn.fnamemodify(vim.uri_to_fname(k.location.uri), ':t')
          k.message = tail ..
              '(' .. (k.location.range.start.line + 1) .. ', ' .. (k.location.range.start.character + 1) ..
              '): ' .. k.message

          if k.location.uri == vim.uri_from_bufnr(0) then
            table.insert(result.diagnostics, {
              code = item.code,
              message = k.message,
              range = k.location.range,
              severity = vim.lsp.protocol.DiagnosticSeverity.Hint,
              source = item.source,
              relatedInformation = {},
            })
          end
        end
        item.message = item.message .. '\n' .. k.message
      end, item.relatedInformation)
    end
  end, result.diagnostics)
  original(_, result, ctx, config)
end

local function switch_source_header_splitcmd(bufnr, splitcmd)
  bufnr = require 'lspconfig'.util.validate_bufnr(bufnr)
  local clangd_client = require 'lspconfig'.util.get_active_client_by_name(bufnr, 'clangd')
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  if clangd_client then
    clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
      if err then
        error(tostring(err))
      end
      if not result then
        print("Corresponding file can’t be determined")
        -- vim.api.nvim_command(":FSHere")
        return
      end
      vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
    end, bufnr)
  else
    print 'textDocument/switchSourceHeader is not supported by the clangd server active on the current buffer'
  end
end
require("lspconfig").clangd.setup {
  cmd = {
    -- see clangd --help-hidden
    get_clangd_path(),
    -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
    -- to add more checks, create .clang-tidy file in the root directory
    -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
    "--background-index",
    "--background-index-priority=low",
    "--clang-tidy",
    "--pch-storage=memory",
    "--completion-style=bundled",
    "--header-insertion=iwyu",
    "--log=error",
    get_clangd_query_driver()
  },
  on_attach = clangd_attach_hints,
  init_options = {
    clangdFileStatus = true, -- Provides information about activity on clangd’s per-file worker thread
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
  commands = {
    ClangdSwitchSourceHeader = {
      function() switch_source_header_splitcmd(0, "edit") end,
      description = "Open source/header in current buffer",
    },
    ClangdSwitchSourceHeaderVSplit = {
      function() switch_source_header_splitcmd(0, "vsplit") end,
      description = "Open source/header in a new vsplit",
    },
    ClangdSwitchSourceHeaderSplit = {
      function() switch_source_header_splitcmd(0, "split") end,
      description = "Open source/header in a new split",
    }
  }
}
-- require('lspconfig').clangd.setup {
-- capabilities = capabilitiesClangd
-- }
require('lspconfig').pylsp.setup {
  capabilities = capabilities
}
require 'lspconfig'.esbonio.setup {
  capabilities = capabilities
}
require('lspconfig').vimls.setup {
  capabilities = capabilities
}
require('lspconfig').cmake.setup {
  capabilities = capabilities,
  init_options = {
    buildDirectory = "out/build/windows-msvc-debug",
    root_pattern = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake', 'out' }
  }
}
require 'lspconfig'.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime files
        library = {
          '${3rd}/luv/library',
          unpack(vim.api.nvim_get_runtime_file("", true)),
        },
      },
      completion = {
        callSnippet = 'Replace',
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- " lua require('lsp_settings').rust()
require 'lspconfig'.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { 'W391' },
          maxLineLength = 100
        }
      }
    }
  }
}
-- " lua require('lsp_settings').viml()
vim.keymap.set('i', '<c-x><c-o>', require('cmp').complete, { remap = false })

-- "
-- " }}}
-- nvim-tree {{{
-- vim.defer_fn(function()
-- require("nvim-tree").setup({
-- sync_root_with_cwd = true,
-- respect_buf_cwd = true,
-- update_focused_file = {
-- enable = true,
-- update_root = true
-- },

-- sort_by = "case_sensitive",
-- hijack_cursor = true,

-- view = {
-- width = 35,
-- mappings = {
-- list = {
-- { key = "u", action = "dir_up" },
-- },
-- },
-- },
-- renderer = {
-- group_empty = true,
-- },
-- filters = {
-- dotfiles = true,
-- },
-- git = {
-- enable = true,
-- ignore = false,
-- show_on_dirs = true,
-- show_on_open_dirs = true,
-- timeout = 400,
-- },
-- })
-- end, 1)

-- }}}


vim.api.nvim_create_augroup("LspAttach_hlargs", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_hlargs",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local caps = client.server_capabilities
    if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
      require("hlargs").disable_buf(args.buf)
    end
  end,
})
vim.api.nvim_create_autocmd("LspDetach", {
  group = "LspAttach_hlargs",
  callback = function(args)
    require("hlargs").enable_buf(args.buf)
  end,
})

-- " }}}

-- vim.api.nvim_create_augroup("LspReferenceStyle", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- group = "LspReferenceStyle",
-- pattern = "*",
-- command =
-- vim.cmd [[
-- hi LspReferenceText gui=underline
-- hi LspReferenceRead gui=underline
-- hi LspReferenceWrite gui=underline
-- ]]
-- })

-- require('overseer').setup()
-- require('dressing').setup()


Signature_help_window_opened = false
Signature_help_forced = false
function My_signature_help_handler(handler)
  return function(...)
    if _G.Signature_help_forced and _G.Signature_help_window_opened then
      _G.Signature_help_forced = false
      return handler(...)
    end
    if _G.Signature_help_window_opened then
      return
    end
    local fbuf, fwin = handler(...)
    if fwin ~= nil then
      _G.Signature_help_window_opened = true
      vim.api.nvim_exec2("autocmd WinClosed " .. fwin .. " lua _G.signature_help_window_opened=false", { output = false })
    end
    return fbuf, fwin
  end
end

function Force_signature_help()
  _G.Signature_help_forced = true
  vim.lsp.buf.signature_help()
end

vim.keymap.set('n', '<space>=', ':keepjumps normal mzgg=Gg`zzz<CR>')

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local bufopt = vim.bo[bufnr]

    local opts = { silent = true, buffer = bufnr }
    local opts2 = { silent = true }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil then
      if client.server_capabilities.completionProvider then
        bufopt.omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.server_capabilities.documentRangeFormattingProvider or client.server_capabilities.documentFormattingProvider then
        bufopt.formatexpr = 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})'
        vim.keymap.set('n', '<Space>=', "<cmd>lua vim.lsp.buf.format()<cr>", opts)
        vim.keymap.set('v', '<Space>=', "<cmd>lua vim.lsp.buf.format()<cr>", opts)
        vim.keymap.set('v', '<Space>gf', "<cmd>lua vim.lsp.formatexpr()<cr>", opts)
      end

      if client.server_capabilities.definitionProvider then
        bufopt.tagfunc = "v:lua.vim.lsp.tagfunc"
      end

      vim.keymap.set('n', '<space>sf', ':ClangdSwitchSourceHeader<CR>')
      vim.keymap.set('n', '<space>sF', ':ClangdSwitchSourceHeaderVSplit<CR>')
      vim.keymap.set('n', '<space>sd', vim.diagnostic.open_float)

      if client.server_capabilities.documentHighlightProvider then
        vim.opt.updatetime = 300
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("CursorHold", {
          callback = vim.lsp.buf.document_highlight,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
          callback = vim.lsp.buf.clear_references,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "Clear All the References",
        })
      end

      if client.server_capabilities.signatureHelpProvider then
        vim.api.nvim_create_augroup("lsp", { clear = true })
        vim.api.nvim_create_autocmd("CursorHoldI", {
          callback = vim.lsp.buf.signature_help,
          buffer = bufnr,
          group = "lsp",
        })
      end
      if client.server_capabilities.hoverProvider then
        vim.keymap.set('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
      end
    end
    vim.keymap.set('n', '<Space>dc', "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set('n', '<space>gd', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<cr>',
      opts)
    vim.keymap.set('n', '<Space>gi', "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set('n', '<C-k>', Force_signature_help, opts)
    vim.keymap.set('i', '<C-k>', Force_signature_help, opts)
    vim.keymap.set('n', '<Space>k', "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set('n', '<Space>gt', "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", opts)
    vim.keymap.set('n', '<Space>gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", opts)
    vim.keymap.set('n', '<Space>gs', "<cmd>Lspsaga outline<cr>", opts)
    vim.keymap.set('n', '<Space>T', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", opts)
    vim.keymap.set('n', '<Space>t', "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", opts2)
    vim.keymap.set('n', '<F12>', "<cmd>lua require('telescope.builtin').lsp_incoming_calls()<cr>", opts)
    vim.keymap.set('n', '<Space>ca', "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    vim.keymap.set('v', '<Space>ca', "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    vim.keymap.set('n', '<Space>cr', "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set("n", "[g", "<cmd>lua vim.diagnostic.goto_prev({float=false})<cr>", opts)
    vim.keymap.set("n", "]g", "<cmd>lua vim.diagnostic.goto_next({float=false})<cr>", opts)
    vim.keymap.set("n", "<space>dd", "<cmd>lua vim.diagnostic.setqflist()<cr>", opts)
    vim.keymap.set('n', '\\wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '\\wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '\\wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  ---@diagnostic disable-next-line: unused-local
  callback = function(args)
    local bufnr = args.buf
    local opts = { silent = true, buffer = bufnr }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil then
      if client.server_capabilities.documentRangeFormattingProvider or client.server_capabilities.documentFormattingProvider then
        vim.keymap.del('n', '<Space>=', opts)
        vim.keymap.del('v', '<Space>=', opts)
      end
    end
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Do something with the client
    vim.cmd("setlocal tagfunc<")
    vim.cmd("set updatetime&")
  end,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "single"
  }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  My_signature_help_handler(vim.lsp.handlers.signature_help),
  {
    border = "single"
  }
)
require("lsp_lines").setup()

vim.diagnostic.config({
  signs = false,
  virtual_text = true,
  virtual_lines = false,
  float = { border = "single" }
}
)
local toggle_diagnostic_text = function()
  local lines_enabled = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({
    virtual_text = lines_enabled,
    virtual_lines = not lines_enabled
  })
end
vim.keymap.set("n", "<space>L", toggle_diagnostic_text, { desc = "Toggle lsp_lines" })

vim.keymap.set('n', '<space>l', ':ClangdToggleInlayHints<cr><c-l>', { silent = true })
-- telescope {{{


local opts = { remap = false }
vim.keymap.set('n', '<Space>r', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<Space>R', '<cmd>Telescope grep_string<CR>', opts)

vim.cmd [[
  command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, <bang>0)
  ]]

vim.keymap.set('n', '<Space>gg', "<cmd>lua require('telescope.builtin').builtin()<cr>", opts)
vim.keymap.set('n', '<Space>?', '<cmd>Telescope help_tags<CR>', opts)
vim.keymap.set('n', '<Space>f', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<Space>F', '<cmd>Telescope git_files<CR>', opts)
vim.keymap.set('n', '<Space><c-F>', '<cmd>Telescope git_status<CR>', opts)
vim.keymap.set('n', '<Space>mr', '<cmd>Telescope oldfiles<CR>', opts)
vim.keymap.set('n', '<Space>mn', "<cmd>lua require('telescope.builtin').keymaps{modes={'n'}}<cr>", opts)
vim.keymap.set('n', '<Space>mx', "<cmd>lua require('telescope.builtin').keymaps{modes={'x'}}<cr>", opts)
vim.keymap.set('n', '<Space>mi', "<cmd>lua require('telescope.builtin').keymaps{modes={'i'}}<cr>", opts)
vim.keymap.set('n', '<Space>mo', "<cmd>lua require('telescope.builtin').keymaps{modes={'o'}}<cr>", opts)
vim.keymap.set('n', '<Space>b', '<cmd>Telescope buffers<CR>', opts)
vim.keymap.set('n', '<Space>h', '<cmd>Telescope<CR>', opts)
-- vim.keymap.set('n', '<Space>T', '<cmd>Telescope current_buffer_tags<CR>', opts)
vim.keymap.set('n', '<Space>O', '<cmd>Telescope projects<CR>', opts)
vim.keymap.set('n', '<Space>o', '<cmd>OverseerToggle<CR>', opts)
vim.keymap.set('n', '<Space>a', '<cmd>ToggleTerm<CR>', opts)
vim.keymap.set('n', '\\c', '<cmd>Telescope colorscheme<CR>', opts)

-- local trouble = require("trouble.providers.telescope")

-- local telescope = require("telescope")

-- telescope.setup {
-- defaults = {
-- mappings = {
-- },
-- },
-- }



-- }}}
--
-- textcase {{{

vim.api.nvim_set_keymap('n', 'ga.', '<cmd>Telescope textcase<CR>', { desc = "Telescope" })
vim.api.nvim_set_keymap('v', 'ga.', "<cmd>Telescope textcase<CR>", { desc = "Telescope" })
-- vim.api.nvim_set_keymap('n', 'gaa', "<cmd>TextCaseOpenTelescopeQuickChange<CR>", { desc = "Telescope Quick Change" })
-- vim.api.nvim_set_keymap('n', 'gai', "<cmd>TextCaseOpenTelescopeLSPChange<CR>", { desc = "Telescope LSP Change" })

-- }}}
--
-- Neoformat {{{
vim.g.neoformat_markdown_remark = {
  exe = "npx",
  args = { 'remark', '--no-color', '--silent', '--config' },
  stdin = 1,
  try_node_exe = 1,
}

