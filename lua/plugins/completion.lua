return {

  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    enabled = false,
    -- dependencies = 'rafamadriz/friendly-snippets',
    dependencies = 'L3MON4D3/LuaSnip',

    -- version = 'v0.*',
    build = 'cargo build --release',
    opts = {
      keymap = {
        preset = 'default',
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
          border = 'padded',

          draw = {
            treesitter = {},
            columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
          }
        },
        documentation = {
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          treesitter_highlighting = true,
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
      },
      snippets = {
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },
      sources = {
        default = { 'lsp', 'path', 'luasnip', 'buffer' },
      },

    },
  },
  {
    'hrsh7th/nvim-cmp',
    lazy = true,
    enabled = true,
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
