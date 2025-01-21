local M = {}

function M.setup_colors()
  local user_colors_id = vim.api.nvim_create_augroup("UserColors", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = user_colors_id,
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "User1",
        {
          ctermfg = 14,
          fg = "#e1a3ee",
          ctermbg = 1,
          bg = "#202020",
          bold = true,
        })
    end
  })

  vim.g.moonflyNormalFloat = true
  vim.g.moonflyWinSeparator = 2

  --vim.cmd [[
  --silent! colorscheme evening
  --silent! colorscheme base16-chalk
  --silent! colorscheme moonfly
  --]]

  require('tokyonight').setup({
    -- style = "day",
    style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
    on_highlights = function(hl, c)
      hl.IncSearch = { bg = "#99663c" }
    end,
    day_brightness = 0.05, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  })
  vim.cmd.colorscheme("tokyonight")
end

return M
