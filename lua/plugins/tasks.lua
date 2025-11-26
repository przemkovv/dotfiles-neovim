---@type LazySpec
return {
  'tpope/vim-dispatch',
  {
    'stevearc/overseer.nvim',
    lazy = true,
    cmd = "OverseerToggle",
    opts = {
      templates = { "builtin", "command_runner", "run_ctest" },
      task_list = {
        direction = "right",
        max_width = { 300, 0.3 },
      }
    },
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = { "ToggleTerm", "TermSelect" },
    opts = {
      direction = "vertical",
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end
    }
  },
}
