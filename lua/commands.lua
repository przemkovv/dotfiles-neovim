-- " Number line settings {{{
local number_lines_id = vim.api.nvim_create_augroup("NumberLines", { clear = true })
local set_norelativenumbers = function()
  vim.opt.relativenumber = false
end
local set_relativenumbers = function()
  if vim.bo.filetype == 'NvimTree'
      or vim.bo.filetype == 'help'
      or vim.bo.filetype == 'neo-tree'
      or vim.bo.filetype == 'DressingInput'
  then
    vim.opt.relativenumber = false
  else
    vim.opt.relativenumber = true
  end
end
vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave", "InsertEnter" },
  {
    group = number_lines_id, pattern = "*", callback = set_norelativenumbers
  })
vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter", "InsertLeave" },
  {
    group = number_lines_id, pattern = "*", callback = set_relativenumbers
  })
-- " }}}

-- When switching buffers, preserve window view. {{{
local save_window_group_id = vim.api.nvim_create_augroup("SaveWindowGroup", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
  group = save_window_group_id,
  pattern = "*",
  callback = require('utils').auto_save_win_view
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = save_window_group_id,
  pattern = "*",
  callback = require('utils').auto_restore_win_view
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- }}}

-- Make directory on save {{{
local make_directory_on_save_id = vim.api.nvim_create_augroup("MakeDirectoryOnSave", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" },
  {
    group = make_directory_on_save_id,
    pattern = "*",
    callback = function(event)
      if vim.bo[event.buf].filetype == 'oil' then
        return
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
  })
-- }}}

-- go to last position when opening file {{{
local go_to_last_position_group_id = vim.api.nvim_create_augroup("GoToLastPosition", { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufReadPost' }, {
  group = go_to_last_position_group_id,
  pattern = "*",
  callback = function()
    local row, column = unpack(vim.api.nvim_buf_get_mark(0, '"'))
    local buf_line_count = vim.api.nvim_buf_line_count(0)

    if row >= 1 and row <= buf_line_count then
      vim.api.nvim_win_set_cursor(0, { row, column })
    end
  end,
})
-- }}}
--
local ft_quickfix_id = vim.api.nvim_create_augroup("ft_quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = ft_quickfix_id,
    pattern = "qf",
    callback = function()
      vim.cmd [[wincmd L]]
      -- vim.cmd [[resize 10]]
      vim.cmd [[setlocal colorcolumn=0 nolist cursorline nowrap tw=0]]
    end
  })
-- " }}}

-- " Vim {{{
local ft_vim_id = vim.api.nvim_create_augroup("ft_vim", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = ft_vim_id,
    pattern = "vim",
    callback = function()
      vim.opt_local.foldmethod = "marker"
    end
  })
vim.api.nvim_create_autocmd("FileType",
  {
    group = ft_vim_id,
    pattern = "help",
    callback = function()
      vim.opt_local.textwidth = 78
    end
  })
vim.api.nvim_create_autocmd("BufWinEnter",
  {
    group = ft_vim_id,
    pattern = "*.txt",
    callback = function()
      if vim.bo.filetype == 'help' then
        vim.cmd [[wincmd L]]
      end
    end
  })

-- }}}

vim.api.nvim_create_user_command('Redir', function(ctx)
  local cmd = ctx.args
  if ctx.range > 0 then
    cmd = ctx.line1 .. "," .. ctx.line2 .. ctx.args
  end
  local lines = vim.split(vim.api.nvim_exec2(cmd, { output = true }).output, '\n', { plain = true })
  vim.cmd('vnew')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command', force = true, range = true })

vim.api.nvim_create_user_command('Redir2Reg', function(ctx)
  local cmd = ctx.args
  if ctx.range > 0 then
    cmd = ctx.line1 .. "," .. ctx.line2 .. ctx.args
  end
  vim.print("Executing: " .. cmd)
  local lines = vim.split(vim.api.nvim_exec2(cmd, { output = true }).output, '\n', { plain = true })
  vim.fn.setreg("", lines, "l")
end, { nargs = '+', complete = 'command', force = true, range = true })
