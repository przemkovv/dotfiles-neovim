--- @type string | nil

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
          end
        end,
      })
    end,
    --   if treesitter_parsers_path ~= nil then
    --     vim.opt.rtp:prepend(treesitter_parsers_path)
    --   end
    --   require('nvim-treesitter.install').compilers = { "clang" }
    --   require('nvim-treesitter.install').prefer_git = false
    --   require("nvim-treesitter.configs").setup(
    --     {
    --       parser_install_dir = treesitter_parsers_path,
    --       modules = {},
    --
    --       highlight = {
    --         enable = true,
    --         disable = function(lang, bufnr) -- Disable in large buffers
    --           return vim.api.nvim_buf_line_count(bufnr) > 50000
    --         end,
    --         -- disable = { "lua", "cpp", "c" },
    --       },
    --       ensure_installed = {
    --         'javascript',
    --         'bash',
    --         'diff',
    --         'typescript',
    --         'tsx',
    --         'css',
    --         'json',
    --         'lua',
    --         'cpp',
    --         'c',
    --         'c_sharp',
    --         'rust',
    --         'python',
    --         'ninja',
    --         'cmake',
    --         'toml',
    --         'markdown',
    --         'markdown_inline',
    --         'vim',
    --         'glsl',
    --         'hlsl',
    --         'vimdoc',
    --         'query',
    --         'rst',
    --         'xml',
    --         'html',
    --         'latex',
    --         'typst',
    --         'yaml'
    --       },
    --       -- Install parsers synchronously (only applied to `ensure_installed`)
    --       sync_install = false,
    --
    --       -- Automatically install missing parsers when entering buffer
    --       auto_install = true,
    --
    --       -- List of parsers to ignore installing (for "all")
    --       ignore_install = {},
    --
    --       indent = {
    --         enable = true
    --       },
    --       textobjects = {
    --         select = {
    --           enable = false,
    --
    --           -- Automatically jump forward to textobj, similar to targets.vim
    --           lookahead = true,
    --
    --           -- keymaps = {
    --           --   -- You can use the capture groups defined in textobjects.scm
    --           --   ["af"] = "@function.outer",
    --           --   ["if"] = "@function.inner",
    --           --   ["ac"] = "@class.outer",
    --           --   ["aC"] = "@comment.outer",
    --           --   ["iC"] = "@comment.inner",
    --           --   ["ia"] = "@parameter.inner",
    --           --   ["aa"] = "@parameter.outer",
    --           --   ["ii"] = "@block.inner",
    --           --   ["ai"] = "@block.outer",
    --           --   -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
    --           --   ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
    --           -- },
    --           -- -- You can choose the select mode (default is charwise 'v')
    --           -- selection_modes = {
    --           --   ['@parameter.outer'] = 'v', -- charwise
    --           --   ['@function.outer'] = 'V',  -- linewise
    --           --   ['@block.inner'] = 'V',     -- linewise
    --           --   ['@block.outer'] = 'V',     -- linewise
    --           --   ['@class.outer'] = '<c-v>', -- blockwise
    --           -- },
    --           -- If you set this to `true` (default is `false`) then any textobject is
    --           -- extended to include preceding xor succeeding whitespace. Succeeding
    --           -- whitespace has priority in order to act similarly to eg the built-in
    --           -- `ap`.
    --           include_surrounding_whitespace = function(a)
    --             if a.query_string == "@block.inner" then
    --               return false
    --             else
    --               return true
    --             end
    --           end
    --         },
    --         swap = {
    --           enable = false,
    --         },
    --
    --       },
    --
    --     })
    -- end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      "lukas-reineke/indent-blankline.nvim",
    }
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter-textobjects',
  --   lazy = false,
  --   -- event = { "BufReadPre", "BufNewFile" },
  -- },
  {
    'nvim-mini/mini.nvim',
    lazy = true,
    event = 'VeryLazy',
    version = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects'
    },
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
      require 'mini.surround'.setup({
        n_lines = 1000,
      })
      require 'mini.move'.setup({
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
      })
      -- require 'mini.notify'.setup(
      --   {
      --     window = {
      --       config = {
      --         width = 70,
      --         anchor = "SW",
      --       },
      --     },
      --   })
      -- local notify_opts = {
      --   INFO = {
      --     duration = 2000,
      --   },
      --   WARN = {
      --     duration = 2000,
      --   },
      --   ERROR = {
      --     duration = 2000,
      --   },
      -- }
      -- vim.notify = require('mini.notify').make_notify(notify_opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = true,
    branch = "main",
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    lazy = true,
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
    opts = {
      enabled = true,
      debounce = 200,
      scope = {},
      indent = { char = '▏' },
    }
  },
}
