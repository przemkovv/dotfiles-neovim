return {

  {
    "dstein64/vim-startuptime",
    lazy = true,
    cmd = "StartupTime"
  },
  {
    'echasnovski/mini.nvim',
    lazy = true,
    event = 'VeryLazy',
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
    'Shatur/neovim-session-manager',
    config = function()
      local cfg = require('session_manager.config')
      require('session_manager').setup({
        autoload_mode = cfg.AutoloadMode.CurrentDir,
        autosave_last_session = true,      -- Automatically save last session on exit and on session switch.
        autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
        autosave_ignore_dirs = {},         -- A list of directories where the session will not be autosaved.
        autosave_ignore_filetypes = {      -- All buffers of these file types will be closed before the session is saved.
          'gitcommit',
          'gitrebase',
        },
        autosave_ignore_buftypes = {},   -- All buffers of these bufer types will be closed before the session is saved.
        autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
        max_path_length = 80,            -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.

      })
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
    lazy = true,
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
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
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
    enabled = false,
    lazy = true,
    cmd = { "Git" }
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",              -- optional
    },
    opts = {
      graph_style = "unicode",
      kind = "replace",
      integrations = {
        fzf_lua = nil,
      }
    },
    config = function(_, opts)
      local neogit = require('neogit')
      neogit.setup(opts)
      vim.keymap.set('n', '<space>gg', function() neogit.open({ kind = "replace" }) end, { desc = "Neogit Replace" })
      vim.keymap.set('n', '<space>GG', function() neogit.open({ kind = "auto" }) end, { desc = "Neogit auto split" })
    end

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
  {
    'norcalli/nvim-colorizer.lua',
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {}
  },
  -- " }}}
  {
    'Wansmer/treesj',
    lazy = true,
    keys = { "<space>j" },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ use_default_keymaps = false })
      vim.keymap.set('n', '<space>j', require('treesj').toggle)
    end,
  },

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
  { 'stsewd/sphinx.nvim',            build = ":UpdateRemotePlugins", ft = 'rst' },
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
    enabled = false,
    ft = { 'rust' },
    config = function() require("rust-tools").setup({}) end
  },
  { 'rust-lang/rust.vim', ft = { 'rust' } },
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
    build = "cd app && npm install",
  },

  -- " }}}
  -- " }}}
}
