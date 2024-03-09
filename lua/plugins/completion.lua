return {

  {
    'hrsh7th/nvim-cmp',
    lazy = true,
    event = "InsertEnter",
    dependencies = {
      { 'hrsh7th/cmp-buffer', },
      { 'amarakon/nvim-cmp-buffer-lines', },
      { 'hrsh7th/cmp-path', },
      { 'FelipeLema/cmp-async-path', },
      { 'hrsh7th/cmp-cmdline', },
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
            mode = 'symbol_text',  -- show only symbol annotations
            maxwidth = 70,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            preset = 'codicons',

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              return vim_item
            end
          })
        },
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body)     -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,

        },
        window = {
          completion = cmp.config.window.bordered(winhighlight),
          documentation = cmp.config.window.bordered(winhighlight),
        },
        mapping = cmp.mapping.preset.insert({
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
            { name = 'vsnip' },   -- For vsnip users.
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
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        }
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'async_path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end

  },
}
