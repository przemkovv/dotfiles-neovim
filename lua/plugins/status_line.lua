---@type LazySpec
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    enabled = false,
    opts = {
      options = {
        icons_enabled = true,
        -- theme = custom_powerline_dark,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },

        lualine_b = {
          -- 'branch',
          'diff',
        },
        lualine_c = {
          { "overseer", unique = true },
          { 'filename', path = 1 },
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'encoding', 'fileformat' },
        lualine_z = {
          'progress',
          'location',
          {
            'diagnostics',
            colored = false,
            always_visible = false,
            sources = {
              'nvim_diagnostic',
            }
          },
        }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "overseer", unique = true },
          { 'filename', path = 1 },
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'encoding', 'fileformat' },
        lualine_z = {
          -- LspStatus,
          'progress',
          'location' }
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {
        'quickfix',
        -- 'nvim-tree',
        'overseer',
        'toggleterm',
        'man',
        'fugitive',
        'oil',
        'lazy',
      }
    },
    config = function(_, opts)
      if package.loaded["sidekick.status"] ~= nil then
        table.insert(opts.sections.lualine_c, {
          function()
            return " "
          end,
          color = function()
            local status = require("sidekick.status").get()
            if status then
              return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
            end
          end,
          cond = function()
            local status = require("sidekick.status")
            return status.get() ~= nil
          end,
        })
      end
      require('lualine').setup(opts)
    end
  },
  {
    'nvim-mini/mini.statusline',
    version = false,
    enabled = true,
    dependencies = { "nvim-mini/mini.icons" },

    opts = {
      use_icons = true,


    },
  },
}
