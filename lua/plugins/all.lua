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
    lazy = true,
    event = 'VimEnter',
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
        vim.keymap.set('n', ']c', function() require("gitsigns").nav_hunk('next', { wrap = true, }) end,
          { buffer = bufnr, desc = "Next Git Hunk" })
        vim.keymap.set('n', '[c', function() require("gitsigns").nav_hunk('prev', { wrap = true, }) end,
          { buffer = bufnr, desc = "Previous Git Hunk" })
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

  'chrisbra/unicode.vim',

  -- Completion {{{

  'Shougo/context_filetype.vim',

  -- }}}

  -- " Dev Tools {{{
  {
    'tpope/vim-fugitive',
    enabled = true,
    lazy = false,
    -- cmd = { "Git" }
  },
  {
    "NeogitOrg/neogit",
    enabled = false,
    -- branch = "nightly",
    -- commit = "fffb448615f45db90b59461a537075d6966e9eda",
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
      vim.keymap.set('n', '<space>gG', function() neogit.open({ kind = "auto" }) end, { desc = "Neogit auto split" })
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
    keys = {
      "<space>J",
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ use_default_keymaps = false })
      vim.keymap.set('n', '<space>J', function()
        require('treesj').toggle({ split = { recursive = true } })
      end)
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
    build = "cd app && npm install && git restore .",
  },
  {
    'willothy/wezterm.nvim',
    enabled = function() if vim.fn.has('win32') == 1 then return true else return false end end,
    config = true,
    lazy = true,
    event = 'VeryLazy'
  },
  {
    "benlubas/molten-nvim",
    enabled = false,
    dependencies = { "willothy/wezterm.nvim" },
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    -- build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
      vim.g.molten_auto_open_output = false
      -- vim.g.molten_image_provider = "image.nvim"
      local NS = { noremap = true, silent = true }
      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
        { silent = true, desc = "Initialize the plugin" })
      vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
        { silent = true, desc = "run operator selection" })
      vim.keymap.set("n", "<localleader>rd", ":MoltenDelete<CR>",
        { silent = true, desc = "delete cell" })
      vim.keymap.set("n", "<localleader>ro", ":MoltenShowOutput<CR>",
        { silent = true, desc = "show output" })
      vim.keymap.set("n", "<localleader>rq", ":noautocmd MoltenEnterOutput<CR>",
        { silent = true, desc = "enter output" })
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>",
        { silent = true, desc = "evaluate line" })
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
        { silent = true, desc = "re-evaluate cell" })
      vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, desc = "evaluate visual selection" })
    end,
  },

  -- " }}}
  -- " }}}
}
