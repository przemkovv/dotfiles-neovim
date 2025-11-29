local M = {}

function M.on_publish_diagnostics_with_related(previous_handler)
  return function(_, result, ctx, config)
    vim.tbl_map(function(item)
      if item.relatedInformation and #item.relatedInformation > 0 then
        vim.tbl_map(function(k)
          if k.location then
            local tail = vim.fn.fnamemodify(vim.uri_to_fname(k.location.uri), ':t')
            k.message = tail ..
                '(' .. (k.location.range.start.line + 1) .. ', ' .. (k.location.range.start.character + 1) ..
                '): ' .. k.message

            if k.location.uri == vim.uri_from_bufnr(0) then
              table.insert(result.diagnostics, {
                code = item.code,
                message = k.message,
                range = k.location.range,
                severity = vim.lsp.protocol.DiagnosticSeverity.Hint,
                source = item.source,
                relatedInformation = {},
              })
            end
          end
          item.message = item.message .. '\n' .. k.message
        end, item.relatedInformation)
      end
    end, result.diagnostics)
    previous_handler(_, result, ctx, config)
  end
end

function M.switch_source_header_splitcmd(bufnr, splitcmd)
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
  local clangd_clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  for clangd_client in clangd_clients do
    if clangd_client then
      clangd_client:request("textDocument/switchSourceHeader", params, function(err, result)
        if err then
          error(tostring(err))
        end
        if not result then
          print("Corresponding file can’t be determined")
          return
        end
        vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
      end, bufnr)
    else
      print 'textDocument/switchSourceHeader is not supported by the LSP server active on the current buffer'
    end
  end
end

function M.workspace_diagnostics()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    client.rpc.request("workspace/diagnostic", { previousResultIds = {} }, function(err, result)
      if err ~= nil then
        print(vim.inspect(err))
      end
      if result ~= nil then
        local diags = {}
        local seen = {}
        for _, diag in ipairs(result.items) do
          local filepath = diag.uri:gsub("file:///", "")
          if #diag.items > 0 then
            for _, diag_line in ipairs(diag.items) do
              if diag_line.severity == 1 then
                local hash = diag_line.message .. diag_line.range.start.line .. diag_line.range.start.character
                if seen[hash] == nil then
                  local s = {
                    text = diag_line.message,
                    lnum = diag_line.range.start.line,
                    col = diag_line.range.start.character,
                    filename = filepath
                  }
                  table.insert(diags, s)
                  seen[hash] = true
                end
              end
            end
          end
        end
        vim.fn.setqflist(diags)
        vim.cmd("copen")
      end
    end)
  end
end

vim.api.nvim_create_user_command('WorkspaceDiagnostics', M.workspace_diagnostics, {
  desc = "Show workspace diagnostics",
  force = true,
})
return M
