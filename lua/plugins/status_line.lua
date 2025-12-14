local get_icon         = function()
  return (require('nvim-web-devicons').get_icon(vim.fn.expand('%:t'), nil, { default = true }))
end
local section_fileinfo = function(args)
  local filetype = vim.bo.filetype

  -- Add filetype icon
  if get_icon ~= nil and filetype ~= '' then filetype = string.format('%s ', get_icon()) end

  -- Construct output string if truncated or buffer is not normal
  if MiniStatusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= '' then return filetype end

  -- Construct output string with extra file info
  local encoding = vim.bo.fileencoding or vim.bo.encoding
  local symbols = {
    unix = '', -- e712
    dos = '', -- e70f
    mac = '', -- e711
  }

  local format = symbols[vim.bo.fileformat]

  return string.format('%s%s%s %s', filetype, filetype == '' and '' or ' ', encoding, format)
end

local section_diff     = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return '' end

  local summary = vim.b.minidiff_summary_string or vim.b.gitsigns_status
  if summary == nil or summary == '' then return '' end

  local icon = ''
  return icon .. ' ' .. (summary == '' and '-' or summary)
end

local section_filename = function(args)
  if vim.bo.buftype == 'terminal' then
    return '%t'
  else
    local file_dir = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.:h')
    -- local file_dir = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.:h'))
    local file_name = vim.fn.fnamemodify(vim.fn.expand('%'), ':t')
    if vim.fn.hlexists('User' .. args.style) then
      return string.format("%s/%%%d*%s%%*%%m%%r", file_dir, args.style, file_name)
    else
      return string.format("%s/%%s%%m%%r", file_dir, file_name)
    end
  end
end

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
      content = {
        active   = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 2000 })
          -- local git           = MiniStatusline.section_git()
          local diff          = section_diff({ trunc_width = 40 })
          local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename      = section_filename({ trunc_width = 140, style = 1 })
          local fileinfo      = section_fileinfo({ trunc_width = 120 })
          local location      = MiniStatusline.section_location({ trunc_width = 75 })
          local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })
          local buffer_id     = string.format('%s', vim.api.nvim_get_current_buf())

          return MiniStatusline.combine_groups({
            { hl = mode_hl,                 strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl,                  strings = { search, location } },
            { hl = 'MiniStatuslineFileinfo', strings = { buffer_id } },
          })
        end,
        -- inactive = function() return '%#MiniStatuslineInactive#%t%=' end
        inactive = function()
          local filename    = section_filename({ trunc_width = 140, style = 2 })
          local buffer_id   = string.format('%s', vim.api.nvim_get_current_buf())
          local diff        = section_diff({ trunc_width = 40 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local lsp         = MiniStatusline.section_lsp({ trunc_width = 75 })
          return MiniStatusline.combine_groups({
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineDevinfo',  strings = { diff, diagnostics, lsp } },
            { hl = 'MiniStatuslineInactive', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { buffer_id } },
          })
        end

      }


    },
  },
}
