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
  return vim.lsp.get_active_clients({ bufno = buf })
end

function M.toggle_diagnostic_text()
  local lines_enabled = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({
    virtual_text = lines_enabled,
    virtual_lines = not lines_enabled
  })
end

return M
