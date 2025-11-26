local M = {}
function M.win_get_var(win_id, var_name)
  local ok, result = pcall(function()
    return vim.api.nvim_win_get_var(win_id, var_name)
  end)

  if ok then
    return result
  end
end

function M.auto_save_win_view()
  local buf = tostring(vim.fn.bufnr("%"))
  local SavedBufView = M.win_get_var(0, "SavedBufView") or {}
  SavedBufView[buf] = vim.fn.winsaveview()
  vim.w.SavedBufView = SavedBufView
end

function M.auto_restore_win_view()
  local buf = tostring(vim.fn.bufnr("%"))
  local SavedBufView = M.win_get_var(0, "SavedBufView")
  if SavedBufView ~= nil and SavedBufView[buf] ~= nil then
    local v = vim.fn.winsaveview()
    if v.lnum == 1 and v.col == 0 then
      vim.fn.winrestview(SavedBufView[buf])
    end
    vim.w.SavedBufView[buf] = nil
  end
end

function M.lsp_status()
  local buf = tostring(vim.fn.bufnr("%"))
  return vim.lsp.get_clients({ bufno = buf })
end

function M.toggle_inlay_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

function M.toggle_diagnostics_current_buffer()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function M.save_session()
  if vim.fn.filereadable('.session.nvim') == 1 then
    vim.cmd('mksession! .session.nvim')
  elseif vim.fn.filereadable('.local_user/session.nvim') == 1 then
    vim.cmd('mksession! .local_user/session.nvim')
  elseif vim.fn.isdirectory('.local_user') == 1 then
    vim.cmd('mksession! .local_user/session.nvim')
  else
    vim.cmd('mksession! .session.nvim')
  end
end

function M.load_session()
  if vim.fn.filereadable('.session.nvim') == 1 then
    vim.cmd('source .session.nvim')
  elseif vim.fn.filereadable('.local_user/session.nvim') == 1 then
    vim.cmd('source .local_user/session.nvim')
  end
end

return M
