return { {
  "przemkovv/adopure.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "sindrets/diffview.nvim" -- Optionally required to open PR in diffview
  },

  lazy = true,
  cmd = "AdoPure",
  config = function()
    vim.g.adopure = {}
    local function set_keymap(keymap, command)
      vim.keymap.set({ "n", "v" }, keymap, function()
        vim.cmd(":" .. command)
      end, { desc = command })
    end
    set_keymap("<space>alc", "AdoPure load context")
    set_keymap("<space>alt", "AdoPure load threads")
    set_keymap("<space>aoq", "AdoPure open quickfix")
    set_keymap("<space>aot", "AdoPure open thread_picker")
    set_keymap("<space>aon", "AdoPure open new_thread")
    set_keymap("<space>aoe", "AdoPure open existing_thread")
    set_keymap("<space>asc", "AdoPure submit comment")
    set_keymap("<space>asv", "AdoPure submit vote")
    set_keymap("<space>ast", "AdoPure submit thread_status")
    set_keymap("<space>asd", "AdoPure submit delete_comment")
    set_keymap("<space>ase", "AdoPure submit edit_comment")
  end,
}
}
