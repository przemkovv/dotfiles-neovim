vim.opt.termguicolors = true

vim.g.loaded = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.api.nvim_command('filetype on')

vim.g.mapleader      = "<Space>"
vim.g.maplocalleader = "\\"

vim.opt.showcmd      = true
vim.opt.showmatch    = true
vim.opt.ignorecase   = true
vim.opt.smartcase    = true
vim.opt.incsearch    = true
vim.opt.inccommand   = "split"
vim.opt.autowrite    = true
vim.opt.hidden       = true
vim.opt.mouse        = "a"
vim.opt.hlsearch     = true
vim.opt.history      = 10000
vim.opt.undolevels   = 1000
vim.opt.sessionoptions:remove { "folds" }
vim.opt.formatoptions = "jcroql/"
vim.opt.virtualedit  = "block"

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
vim.opt.scrolloff = 10
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

vim.opt.colorcolumn = "+1"
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
vim.opt.cursorlineopt = "both"
vim.api.nvim_set_hl(0, "CursorLineNr", { link = "CursorLine" })


vim.opt.switchbuf = "useopen"
vim.opt.showtabline = 1
vim.opt.tabpagemax = 15

vim.opt.grepprg = "rg --vimgrep"

-- " Folding ----------------------------------------------------------------- {{{
vim.opt.foldlevelstart = 99
-- " Make zO recursively open whatever top level fold we're in, no matter where the
-- " cursor happens to be.
vim.keymap.set('n', 'zO', 'zCzO', { silent = false })
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
-- " }}}

vim.o.exrc = true


vim.diagnostic.config({
  signs = false,
  virtual_text = true,
  virtual_lines = false,
  float = {
    border = "single",
    source = "always"
  }
})

vim.lsp.set_log_level("ERROR")

vim.g.nremap = { ['<p'] = '', ['>p'] = '', ['<P'] = '', ['>P'] = '' }

vim.filetype.add({
  extension = {
    glsl = 'glsl',
    hlsl = 'hlsl',
    psh = 'hlsl',
    vsh = 'hlsl',
    fxh = 'hlsl',
  }
})
if vim.fn.has('win32') == 1 and vim.fn.hostname() == 'MA-605' then
  vim.opt.shell = "pwsh"
  vim.opt.shellcmdflag =
  "-NoProfile -NoExit -NoLogo -ExecutionPolicy RemoteSigned -Command  [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText; "
  vim.opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode '
  vim.opt.shellpipe = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode '
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
if vim.fn.has('win32') == 1 and vim.fn.hostname() == 'ARAGORN' then
  local pythonpath = "H:\\dev\\tools\\Python\\Python312"
  vim.g.python3_host_prog = "H:\\dev\\tools\\Python\\Python312\\python.exe"
  vim.opt.rtp:prepend(pythonpath..'Scripts')
  vim.opt.rtp:prepend(pythonpath)
end
