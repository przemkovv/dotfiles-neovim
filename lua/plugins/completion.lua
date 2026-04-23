return {
  {
    "xzbdmw/colorful-menu.nvim",
    config = function()
      -- You don't need to set these options.
      require("colorful-menu").setup({
        -- If the built-in logic fails to find a suitable highlight group for a label,
        -- this highlight is applied to the label.
        fallback_highlight = "@variable",
        -- If provided, the plugin truncates the final displayed text to
        -- this width (measured in display cells). Any highlights that extend
        -- beyond the truncation point are ignored. When set to a float
        -- between 0 and 1, it'll be treated as percentage of the width of
        -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
        -- Default 60.
        max_width = 60,
      })
    end,
  },
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },
    enabled = true,
    -- dependencies = 'rafamadriz/friendly-snippets',
    dependencies = {
      "joelazar/blink-calc"
    },

    version = '1.*',
    -- build = 'cargo +nightly build --release',
    event = 'InsertEnter',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<c-space>'] = false,
        ["<Tab>"] = {
          "snippet_forward",
          -- function() -- sidekick next edit suggestion
          --   return require("sidekick").nes_jump_or_apply()
          -- end,
          function() -- if you are using Neovim's native inline completions
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
      },

      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = {
        menu = {
          auto_show = function(ctx, items)
            return vim.bo.filetype ~= 'markdown'
          end,
          auto_show_delay_ms = 500,
          enabled = true,
          min_width = 30,
          max_height = 15,
          border = 'rounded',
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",

          draw = {
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
                -- },
              },
            }
          }
        },
        documentation = {
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          treesitter_highlighting = true,
          window = {
            border = 'single',
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel"
          },
        }
      },
      signature = {
        enabled = true,
        trigger = {
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          -- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
          show_on_insert_on_trigger_character = true,
        },
        window = {
          border = 'single',
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel"
        },
      },
      cmdline = {
        enabled = false,
        completion = { menu = { auto_show = true } },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'calc' },
        per_filetype = {
          markdown = {
            'lsp',
            'snippets',
            inherit_defaults = false,
          }
        },
        providers = {
          snippets = {
            opts = {
              friendly_snippets = true,
            },
          },
          path = {
            enabled = function()
              return vim.bo.filetype ~= 'copilot-chat'
            end,
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          calc = {
            name = 'Calc',
            module = 'blink-calc',
          },
          -- lazydev = {
          --   name = "LazyDev",
          --   module = "lazydev.integrations.blink",
          --   -- make lazydev completions top priority (see `:h blink.cmp`)
          --   score_offset = 100,
          -- },
        },
      },
    },
    config = function(_, opts)
      local blink_cmp = require('blink.cmp')
      blink_cmp.setup(opts)
      vim.keymap.set('i', '<C-x><C-o>', function()
        require('blink.cmp').show()
        require('blink.cmp').show_documentation()
        require('blink.cmp').hide_documentation()
      end, { silent = false });

      vim.keymap.set('i', '<C-x><C-f>', function()
        require('blink.cmp').show({ providers = { 'path' } })
        require('blink.cmp').show_documentation()
        require('blink.cmp').hide_documentation()
      end, { silent = false });
    end,
  },
}
