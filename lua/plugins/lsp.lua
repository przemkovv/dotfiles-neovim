return {
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require('conform').setup({

        formatters_by_ft = {
          javascript = {
            'prettierd',
            lsp_format = "never",
          },
          typescript = {
            'prettierd',
            lsp_format = "never",
          },
          cmake = {
            "gersemi",
            lsp_format = "never",
          },
        },
        default_format_opts = {
          lsp_format = "prefer",

        },
        -- log_level = vim.log.levels.DEBUG,
      })
      -- vim.o.formatexpr = 'v:lua.require("conform").formatexpr()'
      local opts = { silent = true }
      local conform = require('conform')
      vim.keymap.set('n', '<Space>=', conform.format, opts)
      vim.keymap.set('v', '<Space>=', conform.format, opts)
    end,
  },
  { 'onsails/lspkind.nvim', },
  {
    'neovim/nvim-lspconfig',
  },
  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },

    ft = { "cs" },
  },

  {
    'nvimdev/lspsaga.nvim',
    lazy = true,
    enabled = true,
    event = "LspAttach",
    opts = {
      breadcrumbs = {
        enable = false,
        delay = 3000,
      },
      lightbulb = {
        sign = false,
      },
      outline = {
        layout = "float",
      },
      implement = {
        enable = false,
      },
      beacon = {
        enable = false,
      }
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    }
  },
  {
    'p00f/clangd_extensions.nvim',
    enabled = true,
    ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    lazy = true,
    event = "LspAttach",
    opts = {
      -- These apply to the default ClangdSetInlayHints command
      inlay_hints = {
        inline = 1, --vim.fn.has("nvim-0.10") == 1,
        -- Only show inlay hints for the current line
        only_current_line = false,
        -- Event which triggers a refersh of the inlay hints.
        -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
        -- not that this may cause  higher CPU usage.
        -- This option is only respected when only_current_line and
        -- autoSetHints both are true.
        -- only_current_line_autocmd = { "CursorMoved", "CursorMovedI", "CursorHold" },
        only_current_line_autocmd = { "CursorHold" },
        -- whether to show parameter hints with the inlay hints or not
        show_parameter_hints = true,
        -- prefix for parameter hints
        parameter_hints_prefix = "<- ",
        -- prefix for all the other hints (type, chaining)
        other_hints_prefix = "=> ",
        -- whether to align to the length of the longest line in the file
        max_len_align = false,
        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,
        -- whether to align to the extreme right or not
        right_align = false,
        -- padding from the right if right_align is true
        right_align_padding = 7,
        -- The color of the hints
        highlight = "Comment",
        -- The highlight group priority for extmark
        priority = 100,
      },
      ast = {
        -- These are unicode, should be available in any font
        -- role_icons = {
        --   type = "🄣",
        --   declaration = "🄓",
        --   expression = "🄔",
        --   statement = ";",
        --   specifier = "🄢",
        --   ["template argument"] = "🆃",
        -- },
        -- kind_icons = {
        --   Compound = "🄲",
        --   Recovery = "🅁",
        --   TranslationUnit = "🅄",
        --   PackExpansion = "🄿",
        --   TemplateTypeParm = "🅃",
        --   TemplateTemplateParm = "🅃",
        --   TemplateParamObject = "🅃",
        -- },
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },

        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
        --[[ These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            },
            ]]

        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "rounded",
      },
      symbol_info = {
        border = "rounded",
      },
    }
  },
  {
    'm-demare/hlargs.nvim',
    enabled = false,
    opts = {},
    lazy = true,
    event = "LspAttach",
  },
  {
    'oribarilan/lensline.nvim',
    branch = 'release/2.x', -- or: branch = 'release/2.x' for latest non-breaking updates
    enabled = true,
    -- event = 'LspAttach',
    cmd = { 'LenslineEnable', 'LenslineShow', 'LenslineToggle' },
    config = function()
      require("lensline").setup()
    end,
  },
  {
    "folke/lazydev.nvim",
    enabled = false,
    ft = "lua",   -- only load on lua files
    opts = {
      library = { -- Or relative, which means they will be resolved from the plugin dir.
        "lazy.nvim",
        vim.api.nvim_get_runtime_file("lua", true),
        -- It can also be a table with trigger words / mods
        -- Only load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- always load the LazyVim library
        "LazyVim",
        -- Only load the lazyvim library when the `LazyVim` global is found
        { path = "LazyVim",            words = { "LazyVim" } },
        -- Load the wezterm types when the `wezterm` module is required
        -- Needs `DrKJeff16/wezterm-types` to be installed
        { path = "wezterm-types",      mods = { "wezterm" } },
      },
      -- disable when a .luarc.json file is found
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
    dependencies = {
      {
        'DrKJeff16/wezterm-types',
        lazy = true,
        version = false, -- Get the latest version
      },
    },
  },
}
