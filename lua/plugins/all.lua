return {


  -- " To sort {{{

  { 'stsewd/sphinx.nvim',             build = ":UpdateRemotePlugins" },
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
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
    end,
  },


  'mhinz/vim-signify',
  'ciaranm/securemodelines',
  {
    'MunifTanjim/exrc.nvim',
    opts = {
      files = {
        ".nvimrc.lua",
        ".nvimrc",
        ".exrc.lua",
        ".exrc",
      },
    }
  },

  'scrooloose/nerdcommenter',
  'chrisbra/unicode.vim',

  -- Completion {{{

  'Shougo/context_filetype.vim',

  -- }}}

  -- " Dev Tools {{{
  {
    'tpope/vim-fugitive',
    lazy = true,
    cmd = { "Git" }
  },

  {
    'mattn/gist-vim',
    lazy = true,
    cmd = "Gist",
  },
  'mattn/webapi-vim',
  {
    'Shougo/vinarise.vim',
    lazy = true,
    cmd = "Vinarise"
  },
  { 'diepm/vim-rest-console',         ft = { 'rest' } },
  { 'vim-scripts/DoxygenToolkit.vim', cmd = { 'Dox', 'DoxAuthor', 'DoxBlock', 'DoxLic', 'DoxUndoc' } },
  { 'norcalli/nvim-colorizer.lua',    opts = {} },
  -- " }}}

  -- " Filetype specific {{{
  'sbdchd/neoformat',
  { 'lervag/vimtex',                 ft = { 'tex' } },
  { 'KeitaNakamura/tex-conceal.vim', ft = { 'tex' } },
  { 'wannesm/wmgraphviz.vim',        ft = { 'dot' } },
  { 'chrisbra/csv.vim',              ft = { 'csv' } },
  { 'gennaro-tedesco/nvim-jqx',      ft = { 'json', 'yaml' } },

  -- " HTML/CSS/Javascript/Typescript {{{
  { 'tpope/vim-ragtag',              ft = { 'html' } },
  { 'othree/html5.vim',              ft = { 'html' } },

  { 'leafgarland/typescript-vim',    ft = { 'typescript' } },
  -- " }}}
  -- " Haskell {{{
  { 'neovimhaskell/haskell-vim',     ft = { 'haskell' } },
  { 'enomsg/vim-haskellConcealPlus', ft = { 'haskell' } },
  { 'bitc/vim-hdevtools',            ft = { 'haskell' } },
  -- " }}}
  -- " Rust {{{
  {
    'simrat39/rust-tools.nvim',
    ft = { 'rust' },
    config = function() require("rust-tools").setup({}) end
  },
  { 'rust-lang/rust.vim', ft = { 'rust' } },
  -- " }}}
  -- " }}}
}
