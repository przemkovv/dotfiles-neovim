return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({

        winopts = {
          height = 0.4,
          width = 1,
          row = 0.99,
          col = 0,
        }

      })
    end
  }
}
