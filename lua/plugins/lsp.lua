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
          typescriptreact = {
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
      -- filewatching = "roslyn",
      -- lock_target = true,
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
        debounce = 300,
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
    cmd = { 'LenslineEnable', 'LenslineShow', 'LenslineToggleView' },
    config = function()
      require("lensline").setup()
    end,
  },
  {
    "folke/lazydev.nvim",
    enabled = true,
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
  },
  {
    'DrKJeff16/wezterm-types',
    lazy = false,
    version = false, -- Get the latest version
  },
  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    opts = {
      backend = "delta",
      picker = {
        "snacks",
        opts = {
          layout = {
            layout = {
              backdrop = false,
              width = 0.4,
              min_width = 80,
              height = 0.8,
              border = "none",
              box = "vertical",
              {
                box = "vertical",
                border = true,
                title = "{title} {live} {flags}",
                { win = "input",   height = 1,          border = "bottom" },
                { win = "list",    height = 0.2,        border = "none" },
                { win = "preview", title = "{preview}", border = true, },
              },
            }
          }
        }
      },
      backend_opts = {
        delta = {
          -- Header from delta can be quite large.
          -- You can remove them by setting this to the number of lines to remove
          -- header_lines_to_remove = 4,

          -- The arguments to pass to delta
          -- If you have a custom configuration file, you can set the path to it like so:
          -- args = {
          --     "--config" .. os.getenv("HOME") .. "/.config/delta/config.yml",
          -- }
          args = {
            -- "--line-numbers",
          },
        },
        difftastic = {
          -- header_lines_to_remove = 1,

          -- The arguments to pass to difftastic
          args = {
            "--color=always",
            "--display=inline",
            "--syntax-highlight=on",
          },
        },
      },
      format_title = function(action, _)
        if action.kind then
          return string.format("%s (%s)", action.title, action.kind)
        end
        return action.title
      end,
      signs = {
        quickfix = { "", { link = "DiagnosticWarning" } },
        others = { "", { link = "DiagnosticWarning" } },
        refactor = { "", { link = "DiagnosticInfo" } },
        ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
        ["refactor.extract"] = { "", { link = "DiagnosticError" } },
        ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
        ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
        ["source"] = { "", { link = "DiagnosticError" } },
        ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
        ["codeAction"] = { "", { link = "DiagnosticWarning" } },
      },

    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup(
        {
          options = {
            multilines = {
              enabled = true,
              always_show = true,
            },
            show_related = {
              enabled = true,
              max_count = 3,
            }
          }
        })
      vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
    end,
  }
}
