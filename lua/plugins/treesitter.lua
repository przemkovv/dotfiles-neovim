if vim.fn.hostname() == 'MA-605' then
  vim.g.ts_parsers_path ="d:/dev/tools/nvim-win64/parsers"
else
  vim.g.ts_parsers_path ="h:/dev/tools/Neovim/parsers"
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
      vim.opt.rtp:prepend(vim.g.ts_parsers_path)
      require('nvim-treesitter.install').compilers = { "clang" }
      require("nvim-treesitter.configs").setup(
        {
          parser_install_dir = vim.g.ts_parsers_path,
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
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',

  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
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
