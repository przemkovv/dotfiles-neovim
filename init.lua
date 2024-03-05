vim.loader.enable()
vim.opt.termguicolors = true

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_command('filetype on')
-- vim.opt.runtimepath:append("h:/dev/tools/Neovim/parsers")

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

local packer_bootstrap = require('packages').install()
if packer_bootstrap then
  return
end

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

local data_dir = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
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

vim.g.mapleader = "<Space>"
vim.g.maplocalleader = "\\"

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
-- {{{ lualine

local custom_powerline_dark = require 'lualine.themes.powerline_dark'
custom_powerline_dark.inactive.a.fg = custom_powerline_dark.normal.c.fg
custom_powerline_dark.inactive.b.fg = custom_powerline_dark.normal.c.fg
custom_powerline_dark.inactive.c.fg = custom_powerline_dark.normal.c.fg

local overseer_status = function()
  local overseer = require('overseer')

  local is_running = #overseer.list_tasks({ status = "RUNNING" })
  if is_running > 0 then
    return "%#DiagnosticWarn#R"
  end
  local all_tasks = overseer.list_tasks({ recent_first = true })
  if #all_tasks == 0 then
    return ""
  else
    local status = all_tasks[1].status
    if status == "SUCCESS" then
      return "%#DiagnosticHint#S"
    else
      return "%#DiagnosticError#F"
    end
  end
end

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = custom_powerline_dark,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },

    lualine_b = { 'branch', 'diff' },
    lualine_c = {
      { overseer_status },
      { 'filename',     path = 1 },
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'encoding', 'fileformat' },
    lualine_z = {
      'progress',
      'location',
      {
        'diagnostics',
        colored = false,
        sources = {
          'nvim_diagnostic',
        }
      },
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { overseer_status },
      { 'filename',     path = 1 },
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'encoding', 'fileformat' },
    lualine_z = {
      -- LspStatus,
      'progress',
      'location' }
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { 'quickfix',
    -- 'nvim-tree',
    'overseer', 'trouble', 'toggleterm', 'man', 'fugitive', }

})
-- }}}
-- Hop {{{
-- require 'hop'.setup({
-- keys = 'etovxqpdygfblzhckisuran',
-- multi_windows = true,
-- uppercase_labels = true,

-- })
-- lightspeed {{{
require 'lightspeed'.setup {
  ignore_case = false,
  exit_after_idle_msecs = { unlabeled = nil, labeled = nil },
  --- s/x ---
  jump_to_unique_chars = { safety_timeout = 400 },
  match_only_the_start_of_same_char_seqs = true,
  force_beacons_into_match_width = false,
  -- Display characters in a custom way in the highlighted matches.
  substitute_chars = { ['\r'] = '¬', },
  -- Leaving the appropriate list empty effectively disables "smart" mode,
  -- and forces auto-jump to be on or off.
  -- safe_labels = { . . . },
  -- labels = { . . . },
  -- These keys are captured directly by the plugin at runtime.
  special_keys = {
    next_match_group = '<space>',
    prev_match_group = '<tab>',
  },
  --- f/t ---
  limit_ft_matches = 4,
  repeat_ft_with_target_char = false,
}
-- }}}

-- normal mode (sneak-like)
-- vim.api.nvim_set_keymap("n", "s", "<cmd>HopChar1AC<CR>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "S", "<cmd>HopChar1BC<CR>", { noremap = false })

-- -- visual mode (sneak-like)
-- vim.api.nvim_set_keymap("v", "s", "<cmd>HopChar1AC<CR>", { noremap = false })
-- vim.api.nvim_set_keymap("v", "S", "<cmd>HopChar1BC<CR>", { noremap = false })

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

require("exrc").setup({
  files = {
    ".nvimrc.lua",
    ".nvimrc",
    ".exrc.lua",
    ".exrc",
  },
})
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
require("trouble").setup {
  use_diagnostic_sings = true
}

-- Set up nvim-cmp.
local cmp = require 'cmp'
if cmp == nil then
  return
end
local winhighlight = {
  winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
}
local lspkind = require('lspkind')
cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',  -- show only symbol annotations
      maxwidth = 70,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      preset = 'codicons',

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end
    })
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)     -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,

  },
  window = {
    completion = cmp.config.window.bordered(winhighlight),
    documentation = cmp.config.window.bordered(winhighlight),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'vsnip' },   -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
    },
    {
      { name = 'buffer' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    }),
  completion = {
    autocomplete = false
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      require("clangd_extensions.cmp_scores"),
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  }
})
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
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
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
-- Treesitter {{{{
require("ibl").setup {
  enabled = true,
  debounce = 200,
  scope = {},
  indent = { char = '▏' },
}


require 'treesitter-context'.setup {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'topline',         -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}
require('nvim-treesitter.install').compilers = { "clang" }
require('nvim-treesitter.configs').setup({
  -- parser_install_dir = "h:/dev/tools/Neovim/parsers",
  modules = {},

  highlight = {
    enable = true,
    -- disable = { "lua", "cpp", "c" },
  },
  ensure_installed = {
    'javascript',
    'bash',
    'typescript',
    'tsx',
    'css',
    'json',
    'lua',
    'cpp',
    'c',
    'rust',
    'python',
    'ninja',
    'cmake',
    'toml',
    'markdown',
    'markdown_inline',
    'vim',
    'glsl',
    'hlsl',
    'vimdoc',
    'query',
    'rst',
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  indent = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ia"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",
        -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      },
      -- You can choose the select mode (default is charwise 'v')
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V',  -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding xor succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      include_surrounding_whitespace = true,
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },

  },

})
-- }}}
-- project {{{
require("project_nvim").setup {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  exclude_dirs = { '~/Downloads' },
  detection_methods = { "lsp", "pattern" },
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile" },
}
-- }}}
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
-- oil {{{
require("oil").setup({
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you still want to use netrw.
  default_file_explorer = true,
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  -- Buffer-local options to use for oil buffers
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  -- Window-local options to use for oil buffers
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  delete_to_trash = false,
  -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
  skip_confirm_for_simple_edits = false,
  -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  -- (:help prompt_save_on_select_new_entry)
  prompt_save_on_select_new_entry = true,
  -- Oil will automatically delete hidden buffers after this delay
  -- You can set the delay to false to disable cleanup entirely
  -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
  cleanup_delay_ms = 2000,
  -- Set to true to autosave buffers that are updated with LSP willRenameFiles
  -- Set to "unmodified" to only save unmodified buffers
  lsp_rename_autosave = false,
  -- Constrain the cursor to the editable parts of the oil buffer
  -- Set to `false` to disable, or "name" to keep it on the file names
  constrain_cursor = "editable",
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["gq"] = "actions.add_to_qflist",
    ["<C-q>"] = "actions.send_to_qflist",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = false,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
    sort = {
      -- sort order can be "asc" or "desc"
      -- see :help oil-columns to see which columns are sortable
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  -- Configuration for the floating window in oil.open_float
  float = {
    -- Padding around the floating window
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    -- This is the config that will be passed to nvim_open_win.
    -- Change values here to customize the layout
    override = function(conf)
      return conf
    end,
  },
  -- Configuration for the actions floating preview window
  preview = {
    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a single value or a list of mixed integer/float types.
    -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
    max_width = 0.9,
    -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
    min_width = { 40, 0.4 },
    -- optionally define an integer/float for the exact width of the preview window
    width = nil,
    -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a single value or a list of mixed integer/float types.
    -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
    max_height = 0.9,
    -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
    min_height = { 5, 0.1 },
    -- optionally define an integer/float for the exact height of the preview window
    height = nil,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    -- Whether the preview window is automatically updated when the cursor is moved
    update_on_cursor_moved = true,
  },
  -- Configuration for the floating progress window
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
})
-- }}}
-- neo-tree {{{
require('neo-tree').setup(
  {
    -- If a user has a sources list it will replace this one.
    -- Only sources listed here will be loaded.
    -- You can also add an external source by adding it's name to this list.
    -- The name used here must be the same name you would use in a require() call.
    sources = {
      "filesystem",
      "buffers",
      "git_status",
      -- "document_symbols",
    },
    add_blank_line_at_top = false,            -- Add a blank line at the top of the tree.
    auto_clean_after_session_restore = false, -- Automatically clean up broken neo-tree buffers saved in sessions
    close_if_last_window = false,             -- Close Neo-tree if it is the last window left in the tab
    default_source = "filesystem",            -- you can choose a specific source `last` here which indicates the last used source
    enable_diagnostics = true,
    enable_git_status = true,
    enable_modified_markers = true,        -- Show markers for files with unsaved changes.
    enable_opened_markers = true,          -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
    enable_refresh_on_write = true,        -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
    enable_cursor_hijack = false,          -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
    enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
    git_status_async = true,
    -- These options are for people with VERY large git repos
    git_status_async_options = {
      batch_size = 1000, -- how many lines of git status results to process at a time
      batch_delay = 10,  -- delay in ms between batches. Spreads out the workload to let other processes run.
      max_lines = 10000, -- How many lines of git status results to process. Anything after this will be dropped.
      -- Anything before this will be used. The last items to be processed are the untracked files.
    },
    hide_root_node = false,                                                    -- Hide the root node.
    retain_hidden_root_indent = false,                                         -- IF the root node is hidden, keep the indentation anyhow.
    -- This is needed if you use expanders because they render in the indent.
    log_level = "info",                                                        -- "trace", "debug", "info", "warn", "error", "fatal"
    log_to_file = false,                                                       -- true, false, "/path/to/file.log", use :NeoTreeLogs to show the file
    open_files_in_last_window = true,                                          -- false = open files in top left window
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" }, -- when opening files, do not use windows containing these filetypes or buftypes
    -- popup_border_style is for input and confirmation dialogs.
    -- Configurtaion of floating window is done in the individual source sections.
    -- "NC" is a special style that works well with NormalNC set
    popup_border_style = "NC",   -- "double", "none", "rounded", "shadow", "single" or "solid"
    resize_timer_interval = 500, -- in ms, needed for containers to redraw right aligned and faded content
    -- set to -1 to disable the resize timer entirely
    --                           -- NOTE: this will speed up to 50 ms for 1 second following a resize
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil,           -- uses a custom function for sorting files and directories in the tree
    use_popups_for_input = true,   -- If false, inputs will use vim.ui.input() instead of custom floats.
    use_default_mappings = true,
    -- source_selector provides clickable tabs to switch between sources.
    source_selector = {
      winbar = false,                        -- toggle to show selector on winbar
      statusline = false,                    -- toggle to show selector on statusline
      show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
      -- of the top visible node when scrolled down.
      sources = {
        { source = "filesystem" },
        { source = "buffers" },
        { source = "git_status" },
      },
      content_layout = "start", -- only with `tabs_layout` = "equal", "focus"
      --                start  : |/ 󰓩 bufname     \/...
      --                end    : |/     󰓩 bufname \/...
      --                center : |/   󰓩 bufname   \/...
      tabs_layout = "equal", -- start, end, center, equal, focus
      --             start  : |/  a  \/  b  \/  c  \            |
      --             end    : |            /  a  \/  b  \/  c  \|
      --             center : |      /  a  \/  b  \/  c  \      |
      --             equal  : |/    a    \/    b    \/    c    \|
      --             active : |/  focused tab    \/  b  \/  c  \|
      truncation_character = "…", -- character to use when truncating the tab label
      tabs_min_width = nil, -- nil | int: if int padding is added based on `content_layout`
      tabs_max_width = nil, -- this will truncate text even if `text_trunc_to_fit = false`
      padding = 0, -- can be int or table
      -- padding = { left = 2, right = 0 },
      -- separator = "▕", -- can be string or table, see below
      separator = { left = "▏", right = "▕" },
      -- separator = { left = "/", right = "\\", override = nil },     -- |/  a  \/  b  \/  c  \...
      -- separator = { left = "/", right = "\\", override = "right" }, -- |/  a  \  b  \  c  \...
      -- separator = { left = "/", right = "\\", override = "left" },  -- |/  a  /  b  /  c  /...
      -- separator = { left = "/", right = "\\", override = "active" },-- |/  a  / b:active \  c  \...
      -- separator = "|",                                              -- ||  a  |  b  |  c  |...
      separator_active = nil, -- set separators around the active tab. nil falls back to `source_selector.separator`
      show_separator_on_edge = false,
      --                       true  : |/    a    \/    b    \/    c    \|
      --                       false : |     a    \/    b    \/    c     |
      highlight_tab = "NeoTreeTabInactive",
      highlight_tab_active = "NeoTreeTabActive",
      highlight_background = "NeoTreeTabInactive",
      highlight_separator = "NeoTreeTabSeparatorInactive",
      highlight_separator_active = "NeoTreeTabSeparatorActive",
    },
    --
    default_component_configs = {
      container = {
        enable_character_fade = true,
        width = "100%",
        right_padding = 0,
      },
      --diagnostics = {
      --  symbols = {
      --    hint = "H",
      --    info = "I",
      --    warn = "!",
      --    error = "X",
      --  },
      --  highlights = {
      --    hint = "DiagnosticSignHint",
      --    info = "DiagnosticSignInfo",
      --    warn = "DiagnosticSignWarn",
      --    error = "DiagnosticSignError",
      --  },
      --},
      indent = {
        indent_size = 2,
        padding = 1,
        -- indent guides
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "󰉖",
        folder_empty_open = "󰷏",
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = "*",
        highlight = "NeoTreeFileIcon"
      },
      modified = {
        symbol = "[+] ",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        highlight_opened_files = false, -- Requires `enable_opened_markers = true`.
        -- Take values in { false (no highlight), true (only loaded),
        -- "all" (both loaded and unloaded)}. For more information,
        -- see the `show_unloaded` config of the `buffers` source.
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          -- Change type
          added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
          deleted   = "✖",
          modified  = "",
          renamed   = "󰁕",
          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        },
        align = "right",
      },
      -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
      file_size = {
        enabled = true,
        required_width = 64, -- min width of window required to show this column
      },
      type = {
        enabled = true,
        required_width = 110, -- min width of window required to show this column
      },
      last_modified = {
        enabled = true,
        required_width = 88, -- min width of window required to show this column
      },
      created = {
        enabled = false,
        required_width = 120, -- min width of window required to show this column
      },
      symlink_target = {
        enabled = false,
      },
    },
    renderers = {
      directory = {
        { "indent" },
        { "icon" },
        { "current_filter" },
        {
          "container",
          content = {
            { "name",          zindex = 10 },
            {
              "symlink_target",
              zindex = 10,
              highlight = "NeoTreeSymbolicLinkTarget",
            },
            { "clipboard",     zindex = 10 },
            { "diagnostics",   errors_only = true, zindex = 20,     align = "right",          hide_when_expanded = true },
            { "git_status",    zindex = 10,        align = "right", hide_when_expanded = true },
            { "file_size",     zindex = 10,        align = "right" },
            { "type",          zindex = 10,        align = "right" },
            { "last_modified", zindex = 10,        align = "right" },
            { "created",       zindex = 10,        align = "right" },
          },
        },
      },
      file = {
        { "indent" },
        { "icon" },
        {
          "container",
          content = {
            {
              "name",
              zindex = 10
            },
            {
              "symlink_target",
              zindex = 10,
              highlight = "NeoTreeSymbolicLinkTarget",
            },
            { "clipboard",     zindex = 10 },
            { "bufnr",         zindex = 10 },
            { "modified",      zindex = 20, align = "right" },
            { "diagnostics",   zindex = 20, align = "right" },
            { "git_status",    zindex = 10, align = "right" },
            { "file_size",     zindex = 10, align = "right" },
            { "type",          zindex = 10, align = "right" },
            { "last_modified", zindex = 10, align = "right" },
            { "created",       zindex = 10, align = "right" },
          },
        },
      },
      message = {
        { "indent", with_markers = false },
        { "name",   highlight = "NeoTreeMessage" },
      },
      terminal = {
        { "indent" },
        { "icon" },
        { "name" },
        { "bufnr" }
      }
    },
    nesting_rules = {},
    -- Global custom commands that will be available in all sources (if not overridden in `opts[source_name].commands`)
    --
    -- You can then reference the custom command by adding a mapping to it:
    --    globally    -> `opts.window.mappings`
    --    locally     -> `opt[source_name].window.mappings` to make it source specific.
    --
    -- commands = {              |  window {                 |  filesystem {
    --   hello = function()      |    mappings = {           |    commands = {
    --     print("Hello world")  |      ["<C-c>"] = "hello"  |      hello = function()
    --   end                     |    }                      |        print("Hello world in filesystem")
    -- }                         |  }                        |      end
    --
    -- see `:h neo-tree-custom-commands-global`
    commands = {},               -- A list of functions

    window = {                   -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
      -- possible options. These can also be functions that return these options.
      position = "left",         -- left, right, top, bottom, float, current
      width = 40,                -- applies to left and right positions
      height = 15,               -- applies to top and bottom positions
      auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
      popup = {                  -- settings that apply to float position only
        size = {
          height = "80%",
          width = "50%",
        },
        position = "50%", -- 50% means center it
        -- you can also specify border here, if you want a different setting from
        -- the global popup_border_style.
      },
      same_level = false,  -- Create and paste/move files/directories on the same level as the directory under cursor (as opposed to within the directory under cursor).
      insert_as = "child", -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
      -- "child":   Insert nodes as children of the directory under cursor.
      -- "sibling": Insert nodes  as siblings of the directory under cursor.
      -- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
      -- You can also create your own commands by providing a function instead of a string.
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<space>"] = {
          "toggle_node",
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        -- ["<cr>"] = { "open", config = { expand_nested_files = true } }, -- expand nested file takes precedence
        ["<esc>"] = "cancel", -- close preview or floating neo-tree window
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
        ["l"] = "focus_preview",
        ["S"] = "open_split",
        -- ["S"] = "split_with_window_picker",
        ["s"] = "open_vsplit",
        -- ["sr"] = "open_rightbelow_vs",
        -- ["sl"] = "open_leftabove_vs",
        -- ["s"] = "vsplit_with_window_picker",
        ["t"] = "open_tabnew",
        -- ["<cr>"] = "open_drop",
        -- ["t"] = "open_tab_drop",
        ["w"] = "open_with_window_picker",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        --["Z"] = "expand_all_nodes",
        ["R"] = "refresh",
        ["a"] = {
          "add",
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = "none", -- "none", "relative", "absolute"
          }
        },
        ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ["e"] = "toggle_auto_expand_width",
        ["q"] = "close_window",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
      },
    },
    filesystem = {
      window = {
        mappings = {
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          --["/"] = "filter_as_you_type", -- this was the default until v1.28
          ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ["f"] = "filter_on_submit",
          ["<C-x>"] = "clear_filter",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["i"] = "show_file_details",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["og"] = { "order_by_git_status", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
        },
      },
      async_directory_scan = "auto", -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
      -- "always" means directory scans are always async.
      -- "never"  means directory scans are never async.
      scan_mode = "shallow",            -- "shallow": Don't scan into directories to detect possible empty directory a priori
      -- "deep": Scan into directories to detect empty or grouped empty directories a priori.
      bind_to_cwd = true,               -- true creates a 2-way binding between vim's cwd and neo-tree's root
      cwd_target = {
        sidebar = "tab",                -- sidebar is when position = left or right
        current = "window"              -- current is when position = current
      },
      check_gitignore_in_search = true, -- check gitignore status for files/directories when searching
      -- setting this to false will speed up searches, but gitignored
      -- items won't be marked if they are visible.
      -- The renderer section provides the renderers that will be used to render the tree.
      --   The first level is the node type.
      --   For each node type, you can specify a list of components to render.
      --       Components are rendered in the order they are specified.
      --         The first field in each component is the name of the function to call.
      --         The rest of the fields are passed to the function as the "config" argument.
      filtered_items = {
        visible = false,                       -- when true, they will just be displayed differently than normal items
        force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
        show_hidden_count = true,              -- when true, the number of hidden items in each folder will be shown as the last entry
        hide_dotfiles = true,
        hide_gitignored = false,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          ".DS_Store",
          "thumbs.db"
          --"node_modules",
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json"
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      find_by_full_path_words = false, -- `false` means it only searches the tail of a path.
      -- `true` will change the filter into a full path
      -- search with space as an implicit ".*", so
      -- `fi init`
      -- will match: `./sources/filesystem/init.lua
      --find_command = "fd", -- this is determined automatically, you probably don't need to set it
      --find_args = {  -- you can specify extra args to pass to the find command.
      --  fd = {
      --  "--exclude", ".git",
      --  "--exclude",  "node_modules"
      --  }
      --},
      ---- or use a function instead of list of strings
      --find_args = function(cmd, path, search_term, args)
      --  if cmd ~= "fd" then
      --    return args
      --  end
      --  --maybe you want to force the filter to always include hidden files:
      --  table.insert(args, "--hidden")
      --  -- but no one ever wants to see .git files
      --  table.insert(args, "--exclude")
      --  table.insert(args, ".git")
      --  -- or node_modules
      --  table.insert(args, "--exclude")
      --  table.insert(args, "node_modules")
      --  --here is where it pays to use the function, you can exclude more for
      --  --short search terms, or vary based on the directory
      --  if string.len(search_term) < 4 and path == "/home/cseickel" then
      --    table.insert(args, "--exclude")
      --    table.insert(args, "Library")
      --  end
      --  return args
      --end,
      group_empty_dirs = false,               -- when true, empty folders will be grouped together
      search_limit = 50,                      -- max number of search results when using filters
      follow_current_file = {
        enabled = true,                       -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false,              -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",-- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
    },
    buffers = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,          -- This will find and focus the file in the active buffer every time
        --              -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = true,   -- when true, empty directories will be grouped together
      show_unloaded = false,     -- When working with sessions, for example, restored but unfocused buffers
      -- are mark as "unloaded". Turn this on to view these unloaded buffer.
      terminals_first = false,   -- when true, terminals will be listed before file buffers
      window = {
        mappings = {
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["bd"] = "buffer_delete",
          ["i"] = "show_file_details",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
    git_status = {
      window = {
        mappings = {
          ["A"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
          ["i"] = "show_file_details",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
    document_symbols = {
      follow_cursor = false,
      client_filters = "first",
      renderers = {
        root = {
          { "indent" },
          { "icon",  default = "C" },
          { "name",  zindex = 10 },
        },
        symbol = {
          { "indent",    with_expanders = true },
          { "kind_icon", default = "?" },
          {
            "container",
            content = {
              { "name",      zindex = 10 },
              { "kind_name", zindex = 20, align = "right" },
            }
          }
        },
      },
      window = {
        mappings = {
          ["<cr>"] = "jump_to_symbol",
          ["o"] = "jump_to_symbol",
          ["A"] = "noop", -- also accepts the config.show_path and config.insert_as options.
          ["d"] = "noop",
          ["y"] = "noop",
          ["x"] = "noop",
          ["p"] = "noop",
          ["c"] = "noop",
          ["m"] = "noop",
          ["a"] = "noop",
          ["/"] = "filter",
          ["f"] = "filter_on_submit",
        },
      },
      custom_kinds = {
        -- define custom kinds here (also remember to add icon and hl group to kinds)
        -- ccls
        -- [252] = 'TypeAlias',
        -- [253] = 'Parameter',
        -- [254] = 'StaticMethod',
        -- [255] = 'Macro',
      },
      kinds = {
        Unknown = { icon = "?", hl = "" },
        Root = { icon = "", hl = "NeoTreeRootName" },
        File = { icon = "󰈙", hl = "Tag" },
        Module = { icon = "", hl = "Exception" },
        Namespace = { icon = "󰌗", hl = "Include" },
        Package = { icon = "󰏖", hl = "Label" },
        Class = { icon = "󰌗", hl = "Include" },
        Method = { icon = "", hl = "Function" },
        Property = { icon = "󰆧", hl = "@property" },
        Field = { icon = "", hl = "@field" },
        Constructor = { icon = "", hl = "@constructor" },
        Enum = { icon = "󰒻", hl = "@number" },
        Interface = { icon = "", hl = "Type" },
        Function = { icon = "󰊕", hl = "Function" },
        Variable = { icon = "", hl = "@variable" },
        Constant = { icon = "", hl = "Constant" },
        String = { icon = "󰀬", hl = "String" },
        Number = { icon = "󰎠", hl = "Number" },
        Boolean = { icon = "", hl = "Boolean" },
        Array = { icon = "󰅪", hl = "Type" },
        Object = { icon = "󰅩", hl = "Type" },
        Key = { icon = "󰌋", hl = "" },
        Null = { icon = "", hl = "Constant" },
        EnumMember = { icon = "", hl = "Number" },
        Struct = { icon = "󰌗", hl = "Type" },
        Event = { icon = "", hl = "Constant" },
        Operator = { icon = "󰆕", hl = "Operator" },
        TypeParameter = { icon = "󰊄", hl = "Type" },

        -- ccls
        -- TypeAlias = { icon = ' ', hl = 'Type' },
        -- Parameter = { icon = ' ', hl = '@parameter' },
        -- StaticMethod = { icon = '󰠄 ', hl = 'Function' },
        -- Macro = { icon = ' ', hl = 'Macro' },
      }
    },
    example = {
      renderers = {
        custom = {
          { "indent" },
          { "icon",  default = "C" },
          { "custom" },
          { "name" }
        }
      },
      window = {
        mappings = {
          ["<cr>"] = "toggle_node",
          ["<C-e>"] = "example_command",
          ["d"] = "show_debug_info",
        },
      },
    },
  }
)
-- }}}
require('hlargs').setup()

require('lspsaga').setup({

  lightbulb = {
    sign = false,
  },
  outline = {
    layout = "float",
  }
})

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

require('overseer').setup()
require('dressing').setup()
require("toggleterm").setup {
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end
}

require("clangd_extensions").setup {
  -- These apply to the default ClangdSetInlayHints command
  inlay_hints = {
    inline = 1, --vim.fn.has("nvim-0.10") == 1,
    -- Only show inlay hints for the current line
    only_current_line = false,
    -- Event which triggers a refersh of the inlay hints.
    -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
    -- not that this may cause  higher CPU usage.
    -- This option is only respected when only_current_line and
    -- autoSetHints both are true.
    -- only_current_line_autocmd = { "CursorMoved", "CursorMovedI", "CursorHold" },
    only_current_line_autocmd = { "CursorHold" },
    -- whether to show parameter hints with the inlay hints or not
    show_parameter_hints = true,
    -- prefix for parameter hints
    parameter_hints_prefix = "<- ",
    -- prefix for all the other hints (type, chaining)
    other_hints_prefix = "=> ",
    -- whether to align to the length of the longest line in the file
    max_len_align = false,
    -- padding from the left if max_len_align is true
    max_len_align_padding = 1,
    -- whether to align to the extreme right or not
    right_align = false,
    -- padding from the right if right_align is true
    right_align_padding = 7,
    -- The color of the hints
    highlight = "Comment",
    -- The highlight group priority for extmark
    priority = 100,
  },
  ast = {
    -- These are unicode, should be available in any font
    role_icons = {
      type = "🄣",
      declaration = "🄓",
      expression = "🄔",
      statement = ";",
      specifier = "🄢",
      ["template argument"] = "🆃",
    },
    kind_icons = {
      Compound = "🄲",
      Recovery = "🅁",
      TranslationUnit = "🅄",
      PackExpansion = "🄿",
      TemplateTypeParm = "🅃",
      TemplateTemplateParm = "🅃",
      TemplateParamObject = "🅃",
    },
    --[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            }, ]]

    highlights = {
      detail = "Comment",
    },
  },
  memory_usage = {
    border = "none",
  },
  symbol_info = {
    border = "none",
  },
}

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

local fzf_opts = {
  fuzzy = true,                   -- false will only do exact matching
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true,    -- override the file sorter
  case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
  -- the default case_mode is "smart_case"
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('projects')
-- require("telescope").load_extension("ui-select")
require("telescope").load_extension("notify")
local themes = require('telescope.themes')
require('telescope').setup {

  defaults = themes.get_ivy {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    vimgrep_arguments =
    {
      "rg",
      "--color=never",
      "--no-heading",
      "--hidden",
      "--follow",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--glob",
      "!.git/*",
    },
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close,
        ["<C-w>"] = require('telescope.actions.layout').toggle_preview,
      },
    },
    preview = {
      hide_on_startup = true -- hide previewer when picker starts
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--follow", "--glob", "!.git/*" },
    },
    lsp_dynamic_workspace_symbols = {
      sorter = require('telescope').extensions.fzf.native_fzf_sorter(fzf_opts)
    },
    live_grep = {
    },
    grep_string = {
    },
    git_status = {
      git_icons = {
        added = "+",
        changed = "~",
        copied = ">",
        deleted = "-",
        renamed = "➡",
        unmerged = "‡",
        untracked = "?",
      },
    },


    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    },
    fzf = fzf_opts

  }
}

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

local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
}



-- }}}
--
-- textcase {{{

require('textcase').setup {}
require("telescope").load_extension('textcase')
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

-- return {
-- \ 'exe': 'remark',
-- \ 'args': ['--no-color', '--silent'],
-- \ 'stdin': 1,
-- \ 'try_node_exe': 1,
-- \ }
-- }}}

require 'colorizer'.setup()
require 'mini.notify'.setup(
  {
    window = {
      config = {
        width = 70,
        anchor = "SW",
      },
    },
  })
local notify_opts = { ERROR = { duration = 10000 } }
vim.notify = require('mini.notify').make_notify(notify_opts)
