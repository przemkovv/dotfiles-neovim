local M = {}

function M.setup_colors()
  local user_colors_id = vim.api.nvim_create_augroup("UserColors", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = user_colors_id,
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "IncSearch", { bg = "#99663c" })
      local u1 = vim.api.nvim_get_hl(0, { name = "MiniStatuslineFilename" })
      local u2 = vim.api.nvim_get_hl(0, { name = "MiniStatuslineInactive" })
      u1.bold = true
      u2.bold = true
      vim.api.nvim_set_hl(0, "User1", u1)
      vim.api.nvim_set_hl(0, "User2", u2)

      local url_hl = vim.api.nvim_get_hl(0, { name = "@string.special.url" })
      url_hl.undercurl = false
      url_hl.cterm.undercurl = false
      url_hl.underline = true
      url_hl.cterm.underline = true
      vim.api.nvim_set_hl(0, "@string.special.url", url_hl)
    end
  })

  vim.g.moonflyNormalFloat = true
  vim.g.moonflyWinSeparator = 2
end

return M
