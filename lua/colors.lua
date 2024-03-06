local setup_colors = function()
  vim.api.nvim_create_augroup("UserColors", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = "UserColors",
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "User1",
        { cterm = "bold", ctermfg = 14, fg = "#e1a3ee", ctermbg = 1, bg = "#202020" })
    end
  })

  vim.g.moonflyNormalFloat = true
  vim.g.moonflyWinSeparator = 2


  --vim.cmd [[
--silent! colorscheme evening
--silent! colorscheme base16-chalk
--silent! colorscheme moonfly
--]]
  vim.cmd [[
silent! colorscheme tokyonight-night
]]
end

return {
  setup_colors = setup_colors
}
