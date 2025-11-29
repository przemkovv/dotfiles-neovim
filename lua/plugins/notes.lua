local vaults_root = '~/vaults/'
if vim.fn.has('win32') == 1 and vim.fn.hostname() == 'MA-605' then
  vaults_root = 'c:/Users/pwalkowiak/Documents/vaults/'
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  cmd = { "Obsidian" },
  keys = {
    { "<localleader>oo", '<cmd>Obsidian<cr>',        desc = "Obsidian commands" },
    { "<localleader>oc", '<cmd>Obsidian toggle_checkbox<cr>', desc = "Obsidian checkbox" },
  },
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in the next major release
    workspaces = {
      {
        name = "personal",
        path = vaults_root .. "personal",
      },
      {
        name = "mdg",
        path = vaults_root .. "mdg",
      },
      {
        name = "rtt",
        path = vaults_root .. "rtt",
      },
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)
  end,
}
