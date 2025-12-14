---@type LazySpec
return {
  {
    "dstein64/vim-startuptime",
    lazy = true,
    cmd = "StartupTime"
  },
  {
    -- TODO: This is a todo message.
    -- HACK: This is a hack.
    -- FIXME: This should really be fixed.
    -- NOTE: This is just a note.
    -- LEFTOFF: This is where I left off.
    -- TODO(PW): This is a todo message.
    -- HACK(PW): This is a hack.
    -- FIXME(PW): This should really be fixed.
    -- NOTE(PW): This is just a note.
    -- LEFTOFF(PW): This is where I left off.
    --
    'folke/todo-comments.nvim',
    lazy = false,
    -- event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = true,
      keywords = {
        TODO = { color = "#ff0000" },
        HACK = { color = "#ff6600" },
        NOTE = { color = "#008000" },
        FIX = { color = "#f06292" },
        LEFTOFF = { color = "#ffff99" },
      },
      highlight = {
        pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
        keyword = "fg",
      },
      search = {
        pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]]
      }
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs        = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      numhl        = true,  -- Toggle with `:Gitsigns toggle_numhl`
      linehl       = false, -- Toggle with `:Gitsigns toggle_linehl`
      on_attach    = function(bufnr)
        vim.keymap.set('n', ']c', function() require("gitsigns").nav_hunk('next', { wrap = true, }) end,
          { buffer = bufnr, desc = "Next Git Hunk" })
        vim.keymap.set('n', '[c', function() require("gitsigns").nav_hunk('prev', { wrap = true, }) end,
          { buffer = bufnr, desc = "Previous Git Hunk" })
        vim.keymap.set('n', '<space>gss', '<cmd>Gitsigns<CR>', { buffer = bufnr, desc = "Gitsigns" })
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
    enabled = true,
    config = function()
      require('Comment').setup()
      local ft = require('Comment.ft')
      ft.hlsl = ft.get('cpp')
    end,
    lazy = false,
  },

  {
    'chrisbra/unicode.vim',
    enabled = false,
  },
  {
    'tpope/vim-fugitive',
    enabled = false,
    lazy = false,
    dependencies = {
      'tpope/vim-dispatch',
    }
    -- cmd = { "Git" }
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    event = 'VeryLazy',
    cmd = { 'Neogit', 'NeogitCommit' },
    enabled = true,

    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
    },
    opts = {
      graph_style = "unicode",
      kind = "replace",
      integrations = {
        fzf_lua = false,
        telescope = false,
        mini_pick = false,
        snacks = false,
      }
    },
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
  {
    'mattn/webapi-vim',
    enabled = false,
  },
  {
    'Shougo/vinarise.vim',
    lazy = true,
    cmd = "Vinarise"
  },
  { 'diepm/vim-rest-console',         ft = { 'rest' } },
  { 'vim-scripts/DoxygenToolkit.vim', cmd = { 'Dox', 'DoxAuthor', 'DoxBlock', 'DoxLic', 'DoxUndoc' } },
  {
    'norcalli/nvim-colorizer.lua',
    enabled = false,
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {}
  },
  -- " }}}
  {
    'Wansmer/treesj',
    lazy = true,
    keys = {
      "<space>J",
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false
    },
  },

  {
    'stsewd/sphinx.nvim',
    -- build = ":UpdateRemotePlugins",
    ft = 'rst'
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

  -- " Haskell {{{
  { 'neovimhaskell/haskell-vim',     ft = { 'haskell' } },
  { 'enomsg/vim-haskellConcealPlus', ft = { 'haskell' } },
  { 'bitc/vim-hdevtools',            ft = { 'haskell' } },
  -- " }}}
  -- " Rust {{{
  { 'rust-lang/rust.vim',            ft = { 'rust' } },
  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    config = function()
      require('crates').setup({
        open_programs = { "explorer", "xdg-open", "open" },
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      })
    end,
  },
  -- " }}}
  -- " markdown{{{
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install && git restore .",
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
  },
  -- " }}}
  -- " }}}
}
