vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('przemkovv/big_file', { clear = true }),
  desc = 'Disable features in big files',
  pattern = 'bigfile',
  callback = function(args)
    vim.schedule(function()
      vim.treesitter.stop(args.buf)
      vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or ''
    end)
  end,
})

local line_numbers_group = vim.api.nvim_create_augroup('przemkovv/toggle_line_numbers', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  group = line_numbers_group,
  desc = 'Toggle relative line numbers on',
  callback = function()
    if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  group = line_numbers_group,
  desc = 'Toggle relative line numbers off',
  callback = function(args)
    if vim.wo.nu then
      vim.wo.relativenumber = false
    end

    -- Redraw here to avoid having to first write something for the line numbers to update.
    if args.event == 'CmdlineEnter' then
      if not vim.tbl_contains({ '@', '-' }, vim.v.event.cmdtype) then
        vim.cmd.redraw()
      end
    end
  end,
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
  group = vim.api.nvim_create_augroup('przemkovv//highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = 'Visual' })
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

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('przemkovv/last_location', { clear = true }),
  desc = 'Go to the last location when opening a buffer',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd 'normal! g`"zz'
    end
  end,
})
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
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
    local vstart = vim.fn.getpos "v"
    local vend = vim.fn.getpos "."
    if vstart[2] == vend[2] and vstart[2] == 0 then
      vstart = vim.fn.getpos "v"
      vend = vim.fn.getpos "."
    end
    vim.print { vstart = vstart, vend = vend }
    cmd = vstart[2] .. "," .. vend[2] .. ctx.args
  end
  if ctx.range > 0 then
    cmd = ctx.line1 .. "," .. ctx.line2 .. ctx.args
  end
  local lines = vim.split(vim.api.nvim_exec2(cmd, { output = true }).output, '\n', { plain = true })
  vim.fn.setreg("", lines, "l")
end, { nargs = '+', complete = 'command', force = true, range = true })


vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('przemkovv/close_with_q', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'git',
    'help',
    'man',
    'qf',
    'scratch',
  },
  callback = function(args)
    if args.match ~= 'help' or not vim.bo[args.buf].modifiable then
      vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
    end
  end,
})

vim.api.nvim_create_user_command('Scratch', function()
  vim.cmd 'bel 10new'
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs {
    filetype = 'scratch',
    buftype = 'nofile',
    bufhidden = 'wipe',
    swapfile = false,
    modifiable = true,
  } do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end, { desc = 'Open a scratch buffer', nargs = 0 })

vim.api.nvim_create_user_command('ToggleInlayHints', function()
  vim.g.inlay_hints = not vim.g.inlay_hints
  vim.notify(string.format('%s inlay hints...', vim.g.inlay_hints and 'Enabling' or 'Disabling'), vim.log.levels.INFO)

  local mode = vim.api.nvim_get_mode().mode
  vim.lsp.inlay_hint.enable(vim.g.inlay_hints and (mode == 'n' or mode == 'v'))
end, { desc = 'Toggle inlay hints', nargs = 0 })
