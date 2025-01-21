vim.loader.enable()

require('settings')
require('commands') -- TODO: make it lazy

-- NOTE: for vim-unimpaired

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require('packages').install()
require('colors').setup_colors()
require('cmake_configuration').setup()
require('keymaps')
require('lsp_settings')
