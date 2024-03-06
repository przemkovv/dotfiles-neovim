local packages_install = function()
  local opts = {
    defaults = {
      lazy = false
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
  }

  require('lazy').setup("plugins", opts)
end

return {
  install = packages_install
}
