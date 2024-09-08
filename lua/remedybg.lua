local M = {}

function M.run_debugger()
  if vim.g.remedy_session_file ~= nil then
    vim.notify("Starting debugger")
    vim.fn.jobstart("remedybg.exe -g -q " .. vim.g.remedy_session_file, { detach = 1 })
  end
end

function M.start_debug()
  if vim.g.remedy_session_file ~= nil then
    vim.notify("Starting debugging");
    vim.fn.jobstart("remedybg.exe start-debugging", { detach = 1 })
  end
end

function M.stop_debug()
  if vim.g.remedy_session_file ~= nil then
    vim.notify("Stopping debugging");
    vim.fn.jobstart("remedybg.exe stop-debugging", { detach = 1 })
  end
end

function M.setup()
  if #vim.fn.sign_getdefined("RemedyBreakpoint") == 0 then
    vim.fn.sign_define("RemedyBreakpoint", { text = "B", texthl = "Error" })
  end
end

function M.toggle_breakpoint()
  if vim.g.remedy_session_file ~= nil then
    M.setup()
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    local path = vim.fn.expand('%:p')
    local bufname = vim.fn.bufname()
    local placed = vim.fn.sign_getplaced(bufname, { group = 'RemedyBreakpoint', lnum = linenr })
    if #placed[1].signs == 0 then
      local command_add = "remedybg.exe add-breakpoint-at-file " .. path .. " " .. linenr
      vim.notify("Adding breakpoint");
      vim.fn.jobstart(command_add, { detach = 1 })
      vim.fn.sign_place(0, "RemedyBreakpoint", "RemedyBreakpoint", path, { lnum = linenr, priority = 10 })
    else
      vim.notify("Removing breakpoint");
      local command_remove = "remedybg.exe remove-breakpoint-at-file " .. path .. " " .. linenr
      vim.fn.jobstart(command_remove, { detach = 1 })
      vim.fn.sign_unplace("RemedyBreakpoint", { buffer = bufname, lnum = linenr })
    end
  end
end

return M
