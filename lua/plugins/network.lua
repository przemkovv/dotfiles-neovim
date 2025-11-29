return {
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "\\rs", desc = "Send request" },
      { "\\ra", desc = "Send all requests" },
      { "\\rb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      -- your configuration comes here
      global_keymaps = true,
      global_keymaps_prefix = "\\r",
      kulala_keymaps_prefix = "",

      ui = {
        max_response_size = 128 * 1024 * 1024,
      }
    },
    config = function(_, opts)
      require("kulala").setup(opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'http', 'rest' },
        group = vim.api.nvim_create_augroup('KulalaStartTreesitter', { clear = true }),
        callback = function() vim.treesitter.start() end,
      })
    end,
  }
}
