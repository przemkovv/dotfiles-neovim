return {

  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    enabled = true,
    -- dependencies = 'rafamadriz/friendly-snippets',
    dependencies = 'L3MON4D3/LuaSnip',

    -- version = 'v0.*',
    build = 'cargo build --release',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<c-space>'] = false,
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
          border = 'single',
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
        enabled = true,
        completion = { menu = { auto_show = true } },
      },
      snippets = {
        preset = 'luasnip',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
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
  {
    'hrsh7th/nvim-cmp',
    lazy = true,
    enabled = false,
    event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },
    dependencies = {
      { 'hrsh7th/cmp-buffer', },
      { 'amarakon/nvim-cmp-buffer-lines', },
      { 'hrsh7th/cmp-path', },
      { 'FelipeLema/cmp-async-path', },
      { 'hrsh7th/cmp-cmdline', },
      { 'dmitmel/cmp-cmdline-history' },
      { 'hrsh7th/cmp-nvim-lua', },
      { 'hrsh7th/cmp-nvim-lsp', },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', },
      { 'onsails/lspkind.nvim', },
      { 'saadparwaiz1/cmp_luasnip', },
      { 'L3MON4D3/LuaSnip' },
    },

    config = function()
      local cmp = require 'cmp'
      local winhighlight = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
      }
      local lspkind = require('lspkind')
      local luasnip = require('luasnip')
      local select_opts = { behavior = cmp.SelectBehavior.Insert }
      luasnip.config.setup {}
      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 70, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            preset = 'codicons',
            show_labelDetails = false, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item)
              local MAX_ABBR_WIDTH, MAX_MENU_WIDTH = 50, 70 -- Truncate the label.
              local ellipsis = '…'
              if vim.api.nvim_strwidth(vim_item.abbr) > MAX_ABBR_WIDTH then
                vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, MAX_ABBR_WIDTH) .. ellipsis
              end

              -- Truncate the description part.
              if vim.api.nvim_strwidth(vim_item.menu or '') > MAX_MENU_WIDTH then
                vim_item.menu = vim.fn.strcharpart(vim_item.menu, 0, MAX_MENU_WIDTH) .. ellipsis
              end
              return vim_item
            end
          })
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,

        },
        window = {
          completion = cmp.config.window.bordered(winhighlight),
          documentation = cmp.config.window.bordered(winhighlight),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          ['<C-x><C-o>'] = cmp.mapping.complete {},
          ['<C-x><c-f>'] = cmp.mapping.complete({
            config = {
              sources = {
                { name = 'async_path' }
              }
            }
          }),
          ['<C-x><c-l>'] = cmp.mapping.complete({
            config = {
              sources = {
                { name = 'buffer-lines' }
              }
            }
          }),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources(
          {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'luasnip' }, -- For luasnip users.
          },
          {
            { name = 'buffer' },
          },
          {
            { name = 'async_path' },
            { name = 'buffer-lines' },
          }),
        completion = {
          -- autocomplete = false
        },
        sorting = {
          priority_weight = 1,
          comparators = {
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        }
      })
      -- `/` cmdline setup.
      -- cmp.setup.cmdline('/', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = 'buffer',          max_item_count = 15 },
      --     { name = 'cmdline_history', max_item_count = 15 }
      --   }
      -- })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          {
            { name = 'async_path' }
          },
          {
            { name = 'cmdline',         max_item_count = 40, option = { ignore_cmds = { 'Main', '!', 'T', '%s' } } },
            { name = 'cmdline_history', max_item_count = 40 }
          })
      })
    end

  },
}
