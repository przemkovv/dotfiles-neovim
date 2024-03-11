return {

  'vim-scripts/FSwitch',
  {
    "ahmedkhalf/project.nvim",
    main = "project_nvim",
    opts =
    {
      exclude_dirs = { '~/Downloads' },
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile" },
    }
  },
  {
    "stevearc/oil.nvim",
    lazy = true,
    cmd = "Oil",
    opts = {
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you still want to use netrw.
      default_file_explorer = true,
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        { "permissions", highlight = "Comment" },
        { "size",        highlight = "Comment" },
        { "mtime",       highlight = "Comment" },
        "icon",
      },
      -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["gq"] = "actions.add_to_qflist",
        ["<C-q>"] = "actions.send_to_qflist",
      },
      use_default_keymaps = true,
    }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
    cmd = "Neotree",
    opts = {
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      source_selector = {
        winbar = true,      -- toggle to show selector on winbar
        statusline = false, -- toggle to show selector on statusline
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          { source = "git_status" },
          { source = "document_symbols" },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },
  {
    's1n7ax/nvim-window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require 'window-picker'.setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', "quickfix" },
          },
        },
      })
    end,
  },

}
