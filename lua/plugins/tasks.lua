return {
  'tpope/vim-dispatch',

  {
    'stevearc/overseer.nvim',
    lazy = true,
    cmd = "OverseerToggle",
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = "ToggleTerm",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end
    }
  }
}
