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
  { 'onsails/lspkind.nvim', },
  {
    'neovim/nvim-lspconfig',
  },
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = {
        "marksman",
        -- "glslls",
        "clangd",
        "gersemi",
        "python-lsp-server",
        "json-lsp",
        "esbonio",
        "vim-language-server",
        "slang",
        "lua-language-server",
        "roslyn",
        "lemminx",
        "powershell-editor-services",
        "copilot-language-server",
        "rust-analyzer",
        "cmake-language-server",
        "cmakelang",
        "cmakelint",
        "dockerfile-language-server",
        "jq",
        "jq-lsp",
        "typescript-language-server"
      },

    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mason_registry = require("mason-registry")
      local function install_mason_package(name)
        local package = mason_registry.get_package(name)
        if not package:is_installed() then
          package:install()
        end
      end
      for _, name in ipairs(opts.ensure_installed) do
        install_mason_package(name)
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "marksman",
        -- "glslls",
        "clangd",
        "pylsp",
        "jsonls",
        "esbonio",
        "vimls",
        "slangd",
        "lua_ls",
        "lemminx",
        "powershell_es",
        "copilot",
        "rust_analyzer",
        "cmake",
        "dockerls",
        "jqls",
        "ts_ls"
      },
      automatic_enable = false,
    },
  },
  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },

  {
    'nvimdev/lspsaga.nvim',
    lazy = true,
    enabled = true,
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
    'm-demare/hlargs.nvim',
    enable = false,
    opts = {},
    lazy = true,
    event = "LspAttach",
  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type roslyn.config.RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },
  {
    'oribarilan/lensline.nvim',
    branch = 'release/2.x', -- or: branch = 'release/2.x' for latest non-breaking updates
    enabled = false,
    event = 'LspAttach',
    config = function()
      require("lensline").setup()
    end,
  }
}
