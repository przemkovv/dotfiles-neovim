return {


  -- " To sort {{{

  { "dstein64/vim-startuptime", },
  { 'stsewd/sphinx.nvim',       build = ":UpdateRemotePlugins" },
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

  {
    -- TODO: This is a todo message.
    -- HACK: This is a hack.
    -- FIXME: This should really be fixed.
    -- NOTE: This is just a note.
    -- LEFTOFF: This is where I left off.
    --
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      keywords = {
        TODO = { color = "#ff0000" },
        HACK = { color = "#ff6600" },
        NOTE = { color = "#008000" },
        FIX = { color = "#f06292" },
        LEFTOFF = { color = "#ffff99" },
      },
      highlight = {

        pattern = [[\s+(KEYWORDS)\s*(\([^\)]*\))?:?]],
        keyword = "fg",
      },
      search = {
        pattern = [[\b(KEYWORDS)]], -- ripgrep regex
      }
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs     = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      numhl     = true,  -- Toggle with `:Gitsigns toggle_numhl`
      linehl    = false, -- Toggle with `:Gitsigns toggle_linehl`
      on_attach = function(bufnr)
        vim.keymap.set('n', ']c', require("gitsigns").next_hunk, { buffer = bufnr })
        vim.keymap.set('n', '[c', require("gitsigns").prev_hunk, { buffer = bufnr })
      end
    },
  },
  {
    'ciaranm/securemodelines',
    config = function()
      vim.g.secure_modelines_allowed_items = {
        "textwidth", "tw",
        "foldmethod", "fdm",
        "foldnextmax", "fdn",
        "foldlevel", "foldlevelstart",
        "spelllang", "ft"
      }
    end
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  },

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
    config = function()
      vim.g.gist_post_private = 1
      vim.g.gist_show_privates = 1
      vim.g.gist_detect_filetype = 1
      vim.g.gist_open_browser_after_post = 1
    end
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
  {
    'sbdchd/neoformat',
    config = function()
      vim.g.neoformat_markdown_remark = {
        exe = "npx",
        args = { 'remark', '--no-color', '--silent', '--config' },
        stdin = 1,
        try_node_exe = 1,
      }
    end,
  },
  { 'lervag/vimtex',                 ft = { 'tex' } },
  { 'KeitaNakamura/tex-conceal.vim', ft = { 'tex' } },
  { 'wannesm/wmgraphviz.vim',        ft = { 'dot' } },
  {
    'chrisbra/csv.vim',
    ft = { 'csv' },
    config = function()
      vim.g.csv_autocmd_arrange = 1
    end
  },
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
