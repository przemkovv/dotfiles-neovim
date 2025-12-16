return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      require("nvim-treesitter").install({
        'javascript',
        'bash',
        'diff',
        'typescript',
        'tsx',
        'css',
        'json',
        'lua',
        'cpp',
        'c',
        'c_sharp',
        'latex',
        'regex',
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
        'xml',
        'html',
        'latex',
        'typst',
        'yaml',
        'kulala_http'

      })
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if language and vim.treesitter.language.add(language) then
            vim.treesitter.start()
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo.foldmethod = 'expr'
            if language ~= "markdown" then
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = "main",
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V',  -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      },
    }
  },
  {
    'nvim-mini/mini.ai',
    version = false,
    event = 'VeryLazy',
    config = function()
      local spec_treesitter = require('mini.ai').gen_spec.treesitter
      require('mini.ai').setup({
        custom_textobjects = {
          f = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
          C = spec_treesitter({ a = '@comment.outer', i = '@comment.inner' }),
          o = spec_treesitter({
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          })
        },
        n_lines = 1000,
        mappings = {
          -- Main textobject prefixes
          around = 'a',
          inside = 'i',

          -- Next/last textobjects
          around_next = 'an',
          inside_next = 'in',
          around_last = 'al',
          inside_last = 'il',


          -- Move cursor to corresponding edge of `a` textobject
          goto_left = 'g[',
          goto_right = 'g]',
        },
      })
    end,
  },
  {
    'nvim-mini/mini.surround',
    lazy = true,
    event = 'VeryLazy',
    version = false,
    opts = {
      n_lines = 1000,
    }
  },
  {
    'nvim-mini/mini.move',
    lazy = true,
    event = 'VeryLazy',
    version = false,
    opts = {
      mappings = {
        left       = '<S-left>',
        right      = '<S-right>',
        down       = '<S-down>',
        up         = '<S-up>',

        line_left  = '<S-left>',
        line_right = '<S-right>',
        line_down  = '<S-down>',
        line_up    = '<S-up>',
      }
    }
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    lazy = true,
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      enable = true,           -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 3,           -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 20,  -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 1, -- Maximum number of lines to collapse for a single context line
      trim_scope = 'outer',    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'topline',        -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20,                -- The Z-index of the context window
      on_attach = function(bufnr) -- Disable in large buffers
        return vim.api.nvim_buf_line_count(bufnr) < 10000
      end,
    }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    enabled = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enabled = true,
      debounce = 1000,
      scope = {},
      indent = { char = '▏' },
    }
  },
}
