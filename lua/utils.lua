local function win_get_var(win_id, var_name)
  local ok, result = pcall(function()
    return vim.api.nvim_win_get_var(win_id, var_name)
  end)

  if ok then
    return result
  end
end

local function viewsettings_AutoSaveWinView()
  local buf = tostring(vim.fn.bufnr("%"))
  local SavedBufView = win_get_var(0, "SavedBufView") or {}
  SavedBufView[buf] = vim.fn.winsaveview()
  vim.w.SavedBufView = SavedBufView
end

local function viewsettings_AutoRestoreWinView()
  local buf = tostring(vim.fn.bufnr("%"))
  local SavedBufView = win_get_var(0, "SavedBufView")
  if SavedBufView ~= nil and SavedBufView[buf] ~= nil then
    local v = vim.fn.winsaveview()
    if v.lnum == 1 and v.col == 0 then
      vim.fn.winrestview(SavedBufView[buf])
    end
    vim.w.SavedBufView[buf] = nil
  end


end

local function lsp_status()
  local buf = tostring(vim.fn.bufnr("%"))
  return vim.lsp.get_active_clients({bufno=buf})
end


return {
  auto_save_win_view = viewsettings_AutoSaveWinView,
  auto_restore_win_view = viewsettings_AutoRestoreWinView,
  win_get_var = win_get_var,
  lsp_status = lsp_status
}
