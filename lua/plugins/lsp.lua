return {
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require('conform').setup({

        formatters_by_ft = {
          cmake = {
            "gersemi",
            lsp_format = "never",
          }
        },
        default_format_opts = {
          lsp_format = "prefer",

        }
      })
      vim.o.formatexpr = 'v:lua.require("conform").formatexpr()'
      local opts = { silent = true }
      local conform = require('conform')
      vim.keymap.set('n', '<Space>=', conform.format, opts)
      vim.keymap.set('v', '<Space>=', conform.format, opts)
    end,
  },
  {
    'mrded/nvim-lsp-notify',
    lazy = true,
    enabled = false,
    event = "LspAttach",
  },
  {
    'nvim-lua/lsp-status.nvim',
    enabled = false,
    lazy = true,
    event = "LspAttach",
  },
  {
    'neovim/nvim-lspconfig',
    init = function()
      local lspConfigPath = require("lazy.core.config").options.root .. "/nvim-lspconfig"

      -- INFO `prepend` ensures it is loaded before the user's LSP configs, so
      -- that the user's configs override nvim-lspconfig.
      vim.opt.runtimepath:prepend(lspConfigPath)
    end,
  },
  {
    enabled = true,
    'nvimdev/lspsaga.nvim',
    lazy = true,
    event = "LspAttach",
    opts = {
      breadcrumbs = {
        enable = true,
        delay = 1000,
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
    'jackguo380/vim-lsp-cxx-highlight',
    enabled = false,
    lazy = true,
    event = "LspAttach",
  },
  {
    -- "Maan2003/lsp_lines.nvim",
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    lazy = true,
    event = "LspAttach",
    enabled = true,
    opts = {},
    config = function()
      require("lsp_lines").setup()
    end,
  },
  {
    'p00f/clangd_extensions.nvim',
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
    "folke/trouble.nvim",
    branch = "main",
    cmd = { "TroubleToggle", "Trouble" },
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      use_diagnostic_sings = true
    }
  },
  {
    'm-demare/hlargs.nvim',
    enable = false,
    opts = {},
    lazy = true,
    event = "LspAttach",
  },
  {
    'nvimtools/none-ls.nvim',
    enabled = false,
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        notify_format = "",
        log_level = "off",
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          -- null_ls.builtins.code_actions.refactoring
        }
      })
    end,
    requires = { "nvim-lua/plenary.nvim" },

  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  }
}
