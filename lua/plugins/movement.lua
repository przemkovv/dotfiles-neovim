return {
  'tpope/vim-unimpaired',
  {
    'ggandor/lightspeed.nvim',
    enabled = false,
    opts =
    {
      ignore_case = false,
      exit_after_idle_msecs = { unlabeled = nil, labeled = nil },
      --- s/x ---
      jump_to_unique_chars = { safety_timeout = 400 },
      match_only_the_start_of_same_char_seqs = true,
      force_beacons_into_match_width = false,
      -- Display characters in a custom way in the highlighted matches.
      substitute_chars = { ['\r'] = '¬', },
      -- Leaving the appropriate list empty effectively disables "smart" mode,
      -- and forces auto-jump to be on or off.
      -- safe_labels = { . . . },
      -- labels = { . . . },
      -- These keys are captured directly by the plugin at runtime.
      special_keys = {
        next_match_group = '<space>',
        prev_match_group = '<tab>',
      },
      --- f/t ---
      limit_ft_matches = 4,
      repeat_ft_with_target_char = false,
    }
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
      { "s",        mode = { "n", "x", }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",        mode = { "n", "x", }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "<space>s", mode = { "o" },       function() require("flash").jump() end,              desc = "Flash" },
      { "<space>S", mode = { "o" },       function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",        mode = "o",           function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",        mode = { "o", "x" },  function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>",    mode = { "c" },       function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  'wellle/targets.vim',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  { 'jeetsukumaran/vim-pythonsense', ft = { 'python' } },
  'junegunn/vim-easy-align',

}
