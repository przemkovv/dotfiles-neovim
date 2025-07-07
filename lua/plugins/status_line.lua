local overseer_status = function()
  if not require('lazy.core.config').plugins['overseer.nvim']._.loaded then
    return ""
  end
  local overseer = require('overseer')

  local is_running = #overseer.list_tasks({ status = "RUNNING" })
  if is_running > 0 then
    return "%#DiagnosticWarn#R"
  end
  local all_tasks = overseer.list_tasks({ recent_first = true })
  if #all_tasks == 0 then
    return ""
  else
    local status = all_tasks[1].status
    if status == "SUCCESS" then
      return "%#DiagnosticHint#S"
    else
      return "%#DiagnosticError#F"
    end
  end
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local custom_powerline_dark = require 'lualine.themes.powerline_dark'
      custom_powerline_dark.inactive.a.fg = custom_powerline_dark.normal.c.fg
      custom_powerline_dark.inactive.b.fg = custom_powerline_dark.normal.c.fg
      custom_powerline_dark.inactive.c.fg = custom_powerline_dark.normal.c.fg
      require('lualine').setup({
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
            -- { overseer_status },
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
            -- { overseer_status },
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
      })
    end
  },
}
