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
    },
  }
}
