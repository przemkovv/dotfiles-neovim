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
  bufnr = require 'lspconfig'.util.validate_bufnr(bufnr)
  local clangd_client = require 'lspconfig'.util.get_active_client_by_name(bufnr, 'clangd')
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  if clangd_client then
    clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
      if err then
        error(tostring(err))
      end
      if not result then
        print("Corresponding file can’t be determined")
        -- vim.api.nvim_command(":FSHere")
        return
      end
      vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
    end, bufnr)
  else
    print 'textDocument/switchSourceHeader is not supported by the LSP server active on the current buffer'
  end
end

local Signature_help_window_opened = false
local Signature_help_forced = false
function M.My_signature_help_handler(handler)
  return function(...)
    if Signature_help_forced and Signature_help_window_opened then
      Signature_help_forced = false
      return handler(...)
    end
    if Signature_help_window_opened then
      return
    end
    local fbuf, fwin = handler(...)
    if fwin ~= nil then
      Signature_help_window_opened = true
      vim.api.nvim_exec2("autocmd WinClosed " .. fwin .. " lua _G.signature_help_window_opened=false", { output = false })
    end
    return fbuf, fwin
  end
end

function M.Force_signature_help()
  Signature_help_forced = true
  vim.lsp.buf.signature_help()
end

return M
