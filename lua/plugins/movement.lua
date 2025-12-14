return {
  {
    'tpope/vim-unimpaired',
    enabled = false,
  },
  {
    'tummetott/unimpaired.nvim',
    event = 'VeryLazy',
    opts = {
      -- add options here if you wish to override the default settings
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        }
      }
    },
    -- stylua: ignore
    keys = {
      { "<c-s>",    mode = { "n", "x", }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",        mode = { "n", "x", }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "<space>s", mode = { "o" },       function() require("flash").jump() end,              desc = "Flash" },
      { "<space>S", mode = { "o" },       function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",        mode = "o",           function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",        mode = { "o", "x" },  function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>",    mode = { "c" },       function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  'tpope/vim-repeat',
  { 'jeetsukumaran/vim-pythonsense', ft = { 'python' } },
  {
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign', },
  },

}
