return {
  'tpope/vim-dispatch',
  {
    "nvim-neorg/neorg",
    lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
  },
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
  {
    'kassio/neoterm',
    enabled = false,
    config = function()
      vim.g.neoterm_default_mod = 'botright horizontal'
      vim.g.neoterm_autoscroll = 'true'
    end,
  },
}
