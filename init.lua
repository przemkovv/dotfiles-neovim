vim.opt.termguicolors = true

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_command('filetype on')

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

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  --" Colorschemes {{{
  use 'romainl/Apprentice'
  use 'chriskempson/base16-vim'
  use 'ellisonleao/gruvbox.nvim'
  use 'bluz71/vim-moonfly-colors'
  --" }}}

  --" File navigation {{{
  use 'vim-scripts/FSwitch'
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  })
  use {
    "vigoux/notifier.nvim"
  }

  use { 'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use 'onsails/lspkind.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use { 'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  --" }}}

  -- " To sort {{{
  use 'mbbill/undotree'
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }
  use 'tpope/vim-dispatch'
  -- use 'radenling/vim-dispatch-neovim'
  use { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate" }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use { 'm-demare/hlargs.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' }
  }

  vim.g.nremap = { ['<p'] = '', ['>p'] = '', ['<P'] = '', ['>P'] = '' }
  use 'tpope/vim-unimpaired'


  use 'ciaranm/securemodelines'
  use 'mhinz/vim-signify'
  use 'MunifTanjim/exrc.nvim'

  use 'bronson/vim-trailing-whitespace'
  use 'ryanoasis/vim-devicons'
  use 'scrooloose/nerdcommenter'
  use 'chrisbra/unicode.vim'
  use { 'sbdchd/neoformat', opt = true }

  -- " }}}
  -- " Status bar {{{
  use 'vim-airline/vim-airline'
  -- " }}}

  -- " Search {{{
  use 'phaazon/hop.nvim'
  -- " }}}

  -- " Text Objects {{{
  use 'wellle/targets.vim'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use { 'jeetsukumaran/vim-pythonsense', ft = { 'python' } }
  use 'junegunn/vim-easy-align'
  -- " }}}

  -- Tags {{{
  use 'liuchengxu/vista.vim'
  -- }}}
  -- Completion {{{
  use 'neovim/nvim-lspconfig'
  use 'jackguo380/vim-lsp-cxx-highlight'
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/vim-vsnip-integ' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-path' }
  use { 'saadparwaiz1/cmp_luasnip' }
  use 'hrsh7th/cmp-cmdline'
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-nvim-lua' }
  use { 'hrsh7th/cmp-nvim-lsp-signature-help' }

  use 'Shougo/context_filetype.vim'

  -- }}}
  -- " Snippets {{{
  use { 'rafamadriz/friendly-snippets' }
  -- " }}}

  -- " Dev Tools {{{
  use 'tpope/vim-fugitive'
  use 'gregsexton/gitv'
  use 'mattn/gist-vim'
  use 'mattn/webapi-vim'
  use 'Shougo/vinarise.vim'
  use 'diepm/vim-rest-console'
  use 'vim-scripts/DoxygenToolkit.vim'
  use 'norcalli/nvim-colorizer.lua'
  -- " }}}

  -- " Filetype specific {{{
  use { 'lervag/vimtex', ft = { 'tex' } }
  use { 'KeitaNakamura/tex-conceal.vim', ft = { 'tex' } }
  use 'wannesm/wmgraphviz.vim'
  use { 'chrisbra/csv.vim', ft = { 'csv' } }

  -- " HTML/CSS/Javascript/Typescript {{{
  use { 'tpope/vim-ragtag', ft = { 'html' } }
  use { 'othree/html5.vim', ft = { 'html' } }

  use { 'leafgarland/typescript-vim', ft = { 'typescript' } }
  -- " }}}
  -- " Haskell {{{
  use { 'neovimhaskell/haskell-vim', ft = { 'haskell' } }
  use { 'enomsg/vim-haskellConcealPlus', ft = { 'haskell' } }
  use { 'bitc/vim-hdevtools', ft = { 'haskell' } }
  -- " }}}
  -- " Rust {{{
  use 'rust-lang/rust.vim'
  -- " }}}
  -- " }}}
  -- Automatically vim.opt.up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

if packer_bootstrap then
  return
end

vim.api.nvim_create_augroup("UserColors", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "UserColors",
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "User1",
      { cterm = "bold", ctermfg = 14, fg = "#e1a3ee", ctermbg = 1, bg = "#202020" })
  end
})

vim.g.moonflyNormalFloat = true
vim.g.moonflyWinSeparator = 2


vim.cmd [[
silent! colorscheme evening
silent! colorscheme base16-chalk
silent! colorscheme moonfly
]]

-- When switching buffers, preserve window view. {{{
vim.api.nvim_create_augroup("SaveWindowGroup", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
  group = "SaveWindowGroup",
  pattern = "*",
  -- callback = function() vim.fn["myfunctions#viewsettings#AutoSaveWinView"]() end
  callback = require('utils').auto_save_win_view
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = "SaveWindowGroup",
  pattern = "*",
  callback = require('utils').auto_restore_win_view
  -- callback = function() vim.fn["myfunctions#viewsettings#AutoRestoreWinView"]() end
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
vim.opt.fillchars = { horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋', }

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
vim.opt.cursorline = false

vim.opt.pastetoggle = "<F12>"

-- " Number line settings {{{
local number_lines_id = vim.api.nvim_create_augroup("NumberLines", { clear = true })
local set_norelativenumbers = function() vim.opt.relativenumber = false end
local set_relativenumbers = function() vim.opt.relativenumber = true end
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
    callback = function() vim.fn["myfunctions#utils#AutoMakeDirectory"]() end
  })

vim.opt.switchbuf = "useopen"
vim.opt.showtabline = 1
vim.opt.tabpagemax = 15
vim.api.nvim_command("command! -nargs=+ -complete=file_in_path -bar Grep silent! grep! <args> | redraw!")

vim.opt.grepprg = "rg --vimgrep"

vim.keymap.set('n', '<space>cd', ':cd %:p:h<CR>:pwd<CR>')
vim.keymap.set('n', '<space>sv', ':source $MYVIMRC<CR>')
vim.keymap.set('n', '<Space>ev', ':e  $MYVIMRC<CR>')
vim.keymap.set('n', '<Space>eev', ':vsplit  $MYVIMRC<CR>')
vim.keymap.set('n', '<Space>l', ':s/\\.\\ /\\.\\r/g<CR>:nohl<CR>')
vim.keymap.set('n', '<C-L>', ':nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:sign unplace *<cr><c-l>',
  { silent = true })
vim.keymap.set('n', 'mm', ':Make <CR>', { silent = true })
vim.keymap.set('n', 'mc', ':Make "%:p^"<CR>', { silent = true })
vim.keymap.set('n', 'mt', ':Make check<CR>', { silent = true })

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
vim.keymap.set('n', '<space>1', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<space>3', ':Vista!!<CR>', { silent = true })
vim.keymap.set('n', '<space>4', ':TroubleToggle<CR>', { silent = true })
vim.keymap.set('n', '<space>2', ':UndotreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<F12>', ':set invpaste paste?<CR>', { silent = false })
vim.keymap.set('i', '<F12>', '<C-O>:set invpaste paste?<CR>', { silent = false })
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
-- vim.opt.foldlevelstart = 99
-- " Make zO recursively open whatever top level fold we're in, no matter where the
-- " cursor happens to be.
vim.keymap.set('n', 'zO', 'zCzO', { silent = false })
vim.opt.foldtext = "myfunctions#fold#MyFoldText()"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- " }}}

-- " Filetype-specific ------------------------------------------------------- {{{

-- " QuickFix {{{

vim.api.nvim_create_augroup("ft_quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_quickfix", pattern = "qf", callback = function()
      vim.cmd [[wincmd J]]
      vim.cmd [[resize 10]]
      vim.cmd [[setlocal colorcolumn=0 nolist nocursorline nowrap tw=0]]
    end
  })
-- " }}}
-- " Vim {{{
vim.api.nvim_create_augroup("ft_vim", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_vim", pattern = "vim", callback = function()
      vim.opt_local.foldmethod = "marker"
    end
  })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_vim", pattern = "help", callback = function()
      vim.opt_local.textwidth = 78
    end
  })
vim.api.nvim_create_autocmd("BufWinEnter",
  {
    group = "ft_vim", pattern = "*.txt", callback = function()
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
-- " airline {{{
vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#tabline#enabled'] = 0
vim.g['airline#extensions#tabline#show_buffers'] = 0

vim.g['airline#extensions#vimtex#enabled'] = 1

vim.g['airline#extensions#branch#empty_message'] = "No SCM"
vim.g['airline#extensions#tabline#tab_nr_type'] = 1
vim.g['airline#extensions#hunks#enabled'] = 0
vim.g['airline#extensions#branch#enabled'] = 0
vim.g.airline_inactive_collapse = 1
vim.g.airline_detect_modified = 0

vim.g.airline_left_sep = ''
vim.g.airline_left_alt_sep = ''
vim.g.airline_right_sep = ''
vim.g.airline_right_alt_sep = ''

vim.g['airline#extensions#tabline#left_sep'] = ''
vim.g['airline#extensions#tabline#left_alt_sep'] = ''
vim.g['airline#extensions#tabline#right_sep'] = ''
vim.g['airline#extensions#tabline#right_alt_sep'] = ''

vim.g['airline#extensions#whitespace#trailing_format'] = 'tr[%s]'
vim.g['airline#extensions#whitespace#mixed_indent_format'] = 'mi[%s]'
vim.g['airline#extensions#whitespace#long_format'] = 'long[%s]'
vim.g['airline#extensions#whitespace#mixed_indent_file_format'] = 'mi[%s]'

vim.g.airline_mode_map = {
  ['__'] = '-',
  ['n']  = 'N',
  ['i']  = 'I',
  ['R']  = 'R',
  ['c']  = 'C',
  ['v']  = 'V',
  ['V']  = 'V',
  ['']  = 'V',
  ['s']  = 'S',
  ['S']  = 'S',
  ['']  = 'S',
}
local airline_group = vim.api.nvim_create_augroup("Airline", { clear = true })
vim.api.nvim_create_autocmd("User",
  {
    group = airline_group, pattern = "AirlineAfterInit", callback = function()
      vim.fn["myfunctions#airline#AirlineInit"]()
    end
  })


-- "}}}
-- Hop {{{
require 'hop'.setup({
  keys = 'etovxqpdygfblzhckisuran',
  multi_windows = true,
  uppercase_labels = true,

})

-- normal mode (sneak-like)
vim.api.nvim_set_keymap("n", "s", "<cmd>HopChar1AC<CR>", { noremap = false })
vim.api.nvim_set_keymap("n", "S", "<cmd>HopChar1BC<CR>", { noremap = false })

-- visual mode (sneak-like)
vim.api.nvim_set_keymap("v", "s", "<cmd>HopChar1AC<CR>", { noremap = false })
vim.api.nvim_set_keymap("v", "S", "<cmd>HopChar1BC<CR>", { noremap = false })

-- " Secure Modelines {{{
vim.g.secure_modelines_allowed_items = {
  "textwidth", "tw",
  "foldmethod", "fdm",
  "foldnextmax", "fdn",
  "foldlevel", "foldlevelstart",
  "spelllang",
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
vim.keymap.set('n', '<Space>gs', ':Git<CR>', { remap = false })
vim.keymap.set('n', '<Space>gc', ':Git commit<CR>', { remap = false })
vim.keymap.set('n', '<Space>gl', ':Gclog!<CR>', { remap = false })
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
vim.keymap.set('i', '<c-x><c-f>', '<plug>(fzf-complete-path)', { remap = true })
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

require 'notifier'.setup {
  -- You configuration here
}
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
      mode = 'symbol_text', -- show only symbol annotations
      maxwidth = 70, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
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
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
      { name = 'vsnip' }, -- For vsnip users.
    },
    {
      { name = 'buffer' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
    { name = 'buffer' },
  }),
  completion = {
    autocomplete = false
  }
})
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local capabilitiesClangd = vim.deepcopy(capabilities)
capabilitiesClangd.textDocument.completion.completionItem.snippetSupport = true

require 'lspconfig'.marksman.setup {
  capabilities = capabilities
}
require('lspconfig').rls.setup {
  capabilities = capabilities
}
require('lspconfig').rust_analyzer.setup {
  capabilities = capabilities
}
require('lspconfig').clangd.setup {
  capabilities = capabilitiesClangd
}
require('lspconfig').pylsp.setup {
  capabilities = capabilities
}
require('lspconfig').vimls.setup {
  capabilities = capabilities
}
require('lspconfig').cmake.setup {
  capabilities = capabilities
}
require 'lspconfig'.sumneko_lua.setup {
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
-- " lua require('lsp_settings').python()
-- " lua require('lsp_settings').viml()
vim.keymap.set('i', '<c-x><c-o>', require('cmp').complete, { remap = false })


-- "
-- " }}}
-- Treesitter {{{{
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  ensure_installed = {
    'javascript',
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
    'markdown',
    'markdown_inline',
    'vim'
  },

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
        ['@function.outer'] = 'V', -- linewise
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
-- nvim-tree {{{
require("nvim-tree").setup({

  sort_by = "case_sensitive",
  hijack_cursor = true,

  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- }}}
require('hlargs').setup()
-- " }}}

vim.api.nvim_create_augroup("LspReferenceStyle", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "LspReferenceStyle",
  pattern = "*",
  command =
  vim.cmd [[
    hi LspReferenceText gui=underline
    hi LspReferenceRead gui=underline
    hi LspReferenceWrite gui=underline
]]
})

signature_help_window_opened = false
signature_help_forced = false
function my_signature_help_handler(handler)
  return function(...)
    if _G.signature_help_forced and _G.signature_help_window_opened then
      _G.signature_help_forced = false
      return handler(...)
    end
    if _G.signature_help_window_opened then
      return
    end
    local fbuf, fwin = handler(...)
    if fwin ~= nil then
      _G.signature_help_window_opened = true
      vim.api.nvim_exec("autocmd WinClosed " .. fwin .. " lua _G.signature_help_window_opened=false", false)
    end
    return fbuf, fwin
  end
end

function force_signature_help()
  _G.signature_help_forced = true
  vim.lsp.buf.signature_help()
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local bufopt = vim.bo[bufnr]

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.completionProvider then
      bufopt.omnifunc = "v:lua.vim.lsp.omnifunc"

    end
    bufopt.formatexpr = 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})'
    if client.server_capabilities.definitionProvider then
      bufopt.tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    local opts = { silent = true, buffer = bufnr }
    vim.keymap.set('n', '<Space>dc', "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set('n', '<Space>gd', "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.keymap.set('n', '<Space>gi', "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set('n', '<C-k>', '<cmd>lua force_signature_help()<CR>', opts)
    vim.keymap.set('i', '<C-k>', '<cmd>lua force_signature_help()<CR>', opts)
    vim.keymap.set('n', '<Space>=', "<cmd>lua vim.lsp.buf.format()<cr>", opts)
    vim.keymap.set('v', '<Space>gf', "<cmd>lua vim.lsp.formatexpr()<cr>", opts)
    vim.keymap.set('n', '<Space>k', "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set('n', '<Space>gt', "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    vim.keymap.set('n', '<Space>gr', "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.keymap.set('n', '<Space>ga', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", opts)
    vim.keymap.set('n', '<Space>gA', "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", opts)
    vim.keymap.set('n', '<Space>ca', "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    vim.keymap.set("n", "[g", "<cmd>lua vim.diagnostic.goto_prev({float=false})<cr>", opts)
    vim.keymap.set("n", "]g", "<cmd>lua vim.diagnostic.goto_next({float=false})<cr>", opts)

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
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
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
  my_signature_help_handler(vim.lsp.handlers.signature_help),
  {
    border = "single"
  }
)
require("lsp_lines").setup()

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
  float = { border = "single" }
}
)
vim.keymap.set("n", "<space>L", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })

-- telescope {{{
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
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--follow", "--glob", "!.git/*" },

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
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}
require('telescope').load_extension('fzf')

local opts = { remap = false }
vim.keymap.set('n', '<Space>r', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<Space>R', '<cmd>Telescope grep_string<CR>', opts)

vim.cmd [[
  command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
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
vim.keymap.set('n', '<Space>t', '<cmd>Telescope tags<CR>', opts)
vim.keymap.set('n', '<Space>T', '<cmd>Telescope current_buffer_tags<CR>', opts)
vim.keymap.set('n', '\\c', '<cmd>Telescope colorscheme<CR>', opts)
-- }}}

require 'colorizer'.setup()
