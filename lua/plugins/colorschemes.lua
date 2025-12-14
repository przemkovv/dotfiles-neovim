return {
  {
    'chriskempson/base16-vim',
    enabled = false,
    lazy = false,
    priority = 1000,
  },
  {
    'ellisonleao/gruvbox.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require('gruvbox').setup(opts)
      -- vim.cmd.colorscheme("gruvbox")
    end
  },
  {
    'bluz71/vim-moonfly-colors',
    enabled = false,
    lazy = false,
    priority = 1000,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      -- style = "day",
      style = "night",     -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
      transparent = true,  -- Enable this to disable setting the background color
      lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
      styles = {
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent", -- style for sidebars, see below
        floats = "transparent",   -- style for floating windows
      },
      day_brightness = 0.05,      -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      cache = true,               -- When set to true, the theme will be cached for better performance
    },

    config = function(_, opts)
      require('tokyonight').setup(opts)
      -- vim.cmd.colorscheme("tokyonight")
    end
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = true,
    priority = 1000,
    opts = {
      compile = true,  -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,   -- do not set background color
      dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = {             -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) -- add/modify highlights
        return {}
      end,
      theme = "wave",    -- Load "wave" theme
      background = {     -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus"
      },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end

  }
}
