return {

  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },
    enabled = true,
    -- dependencies = 'rafamadriz/friendly-snippets',
    dependencies = {
      "joelazar/blink-calc"
    },

    -- version = 'v0.*',
    build = 'cargo +nightly build --release',
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
          auto_show = true,
          enabled = true,
          min_width = 30,
          max_height = 15,
          -- winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
          border = 'rounded',
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",

          -- draw = {
          --   treesitter = {},
          --   columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
          -- }
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              }
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
        default = {  'lsp', 'path', 'snippets', 'buffer', 'calc' },
        -- per_filetype = {
        --   lua = { inherit_defaults = true, 'lazydev' }
        -- },
        providers = {
          snippets = {
            opts = {
              friendly_snippets = true,
            },
          },
          path = {
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
