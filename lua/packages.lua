local M = {}

function M.install()
  local opts = {
    defaults = {
      lazy = false
    },
    spec = {
      -- import your plugins
      { import = "plugins" },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "matchit",
          "tar",
          "tarPlugin",
          "rrhelper",
          "spellfile_plugin",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
        },
      },
    },
    -- automatically check for plugin updates
    checker = { enabled = false },
  }

  require('lazy').setup(opts)
end

return M
