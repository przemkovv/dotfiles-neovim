return { {
  "przemkovv/adopure.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "sindrets/diffview.nvim" -- Optionally required to open PR in diffview
  },

  lazy = true,
  cmd = "AdoPure",
  keys = {
    { "<space>alc", "<cmd>AdoPure load context<cr>",          mode = { "n", "v" } },
    { "<space>auc", "<cmd>AdoPure unload<cr>",                mode = { "n", "v" } },
    { "<space>alt", "<cmd>AdoPure load threads<cr>",          mode = { "n", "v" } },
    { "<space>aoq", "<cmd>AdoPure open quickfix<cr>",         mode = { "n", "v" } },
    { "<space>aot", "<cmd>AdoPure open thread_picker<cr>",    mode = { "n", "v" } },
    { "<space>aon", "<cmd>AdoPure open new_thread<cr>",       mode = { "n", "v" } },
    { "<space>aoe", "<cmd>AdoPure open existing_thread<cr>",  mode = { "n", "v" } },
    { "<space>asc", "<cmd>AdoPure submit comment<cr>",        mode = { "n", "v" } },
    { "<space>asv", "<cmd>AdoPure submit vote<cr>",           mode = { "n", "v" } },
    { "<space>ast", "<cmd>AdoPure submit thread_status<cr>",  mode = { "n", "v" } },
    { "<space>asd", "<cmd>AdoPure submit delete_comment<cr>", mode = { "n", "v" } },
    { "<space>ase", "<cmd>AdoPure submit edit_comment<cr>",   mode = { "n", "v" } }
  },
  config = function()
    vim.g.adopure = {}
  end,
}
}
