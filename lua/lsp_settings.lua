local M = {}

-- Disable inlay hints initially (and enable if needed with my ToggleInlayHints command).
vim.g.inlay_hints = false


M.enable_lsp_severs = {
  'marksman',
  'glslls',
  'clangd',
  'pylsp',
  'jsonls',
  'esbonio',
  'vimls',
  'slangd',
  'lua_ls',
  'roslyn',
  'lemminx',
  'powershell_es',
  'copilot',
  'rust_analyzer',
  'dockerls',
  'jqls',
  'ts_ls',
  'kulala_ls',
}

vim.lsp.on_type_formatting.enable(true)
vim.lsp.semantic_tokens.enable(true)


--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts string|vim.keymap.set.Opts
  ---@param mode? string|string[]
  local function keymap(lhs, rhs, opts, mode)
    mode = mode or 'n'
    ---@cast opts vim.keymap.set.Opts
    opts = type(opts) == 'string' and { desc = opts } or opts
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  if client.server_capabilities.completionProvider then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
  end
  if client.server_capabilities.documentRangeFormattingProvider or client.server_capabilities.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})'
  end

  if client.server_capabilities.inlayHintProvider then
    if client:supports_method 'textDocument/inlayHint' then
      local inlay_hints_group = vim.api.nvim_create_augroup('przemkovv/toggle_inlay_hints', { clear = false })

      if vim.g.inlay_hints then
        -- Initial inlay hint display.
        -- Idk why but without the delay inlay hints aren't displayed at the very start.
        vim.defer_fn(function()
          local mode = vim.api.nvim_get_mode().mode
          vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = bufnr })
        end, 500)
      end

      vim.api.nvim_create_autocmd('InsertEnter', {
        group = inlay_hints_group,
        desc = 'Enable inlay hints',
        buffer = bufnr,
        callback = function()
          if vim.g.inlay_hints then
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          end
        end,
      })

      vim.api.nvim_create_autocmd('InsertLeave', {
        group = inlay_hints_group,
        desc = 'Disable inlay hints',
        buffer = bufnr,
        callback = function()
          if vim.g.inlay_hints then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })
    end
  end

  if client:supports_method('textDocument/foldingRange') then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end

  if client.name == 'clangd' then
    keymap('<space>sf', ':ClangdSwitchSourceHeader<CR>', 'Switch source header', 'n')
    keymap('<space>sF', ':ClangdSwitchSourceHeaderVSplit<CR>', 'Switch source header in split', 'n')
  end

  if client:supports_method 'textDocument/documentHighlight' then
    local under_cursor_highlights_group =
        vim.api.nvim_create_augroup('przemkovv/cursor_highlights', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
      group = under_cursor_highlights_group,
      desc = 'Highlight references under the cursor',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
      group = under_cursor_highlights_group,
      desc = 'Clear highlight references',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method('textDocument/inlayHint') then
    keymap('<space>l', '<cmd>ToggleInlayHints<CR>', 'Toggle inlay hints', 'n')
  end

  if client:supports_method('textDocument/definition') then
    keymap("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
    keymap('<space>gp', "<cmd>Lspsaga peek_definition<cr>", 'Peek definition', 'n')
  end

  if client:supports_method('textDocument/declaration') then
    keymap("gD", function() Snacks.picker.lsp_declarations() end, "Goto Declarations")
  end

  if client.server_capabilities.hoverProvider then
    keymap('<C-k>', vim.lsp.buf.signature_help, 'Signature help', { 'n', 'i' })
  end

  if client:supports_method('textDocument/typeDefinition') then
    keymap('grt', function() Snacks.picker.lsp_type_definitions() end, 'Type definitions', 'n')
  end

  if client:supports_method('textDocument/references') then
    keymap('grr', function() Snacks.picker.lsp_references() end, 'References', 'n')
  end

  if client:supports_method('textDocument/documentSymbol') then
    keymap('gO', function() Snacks.picker.lsp_symbols() end, 'Document symbols', 'n')
    keymap('<space>gs', "<cmd>Lspsaga outline<cr>", 'Outline', 'n')
  end

  if client:supports_method('workspace/symbol') then
    keymap('<space>t', function() Snacks.picker.lsp_workspace_symbols() end, 'Workspace symbols', 'n')
  end

  if client:supports_method('textDocument/implementation') then
    keymap('gI', function() Snacks.picker.lsp_implementations() end, 'Implementation', 'n')
  end

  if client:supports_method('callHierarchy/incomingCalls') then
    keymap('gai', function() Snacks.picker.lsp_incoming_calls() end, 'Incoming calls', 'n')
    keymap('gao', function() Snacks.picker.lsp_outgoing_calls() end, 'Outgoing calls', 'n')
  end

  if client:supports_method('textDocument/inlineCompletion') then
    vim.lsp.inline_completion.enable(true)
    vim.keymap.set('i', '<Tab>', function()
      if not vim.lsp.inline_completion.get() then
        return '<Tab>'
      end
    end, { expr = true, desc = 'Accept the current inline completion' })
    vim.keymap.set('i', '<c-.>', function() vim.lsp.inline_completion.select({ count = 1 }) end,
      { expr = true, desc = 'Next suggestion' })
    vim.keymap.set('i', '<c-,>', function() vim.lsp.inline_completion.select({ count = -1 }) end,
      { expr = true, desc = 'Prev suggestion' })
  end


  vim.lsp.handlers['textDocument/publishDiagnostics'] = require('lsp_utils').on_publish_diagnostics_with_related(vim.lsp
    .handlers['textDocument/publishDiagnostics'])

  keymap('\\wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder', 'n')
  keymap('\\wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder', 'n')
  keymap('\\wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'List workspace folders', 'n')
end

---@param client vim.lsp.Client
---@param bufnr integer
local function on_dettach(client, bufnr)

end

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local value = ev.data.params.value
    if value == nil then
      return
    end
    if value.kind == 'begin' then
      io.stdout:write('\027]9;4;1;0\027\\')
    elseif value.kind == 'end' then
      io.stdout:write('\027]9;4;0\027\\')
    elseif value.kind == 'report' then
      io.stdout:write(string.format('\027]9;4;1;%d\027\\', value.percentage))
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})
vim.api.nvim_create_autocmd('LspDetach', {
  desc = 'Deconfigure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- I don't think this can happen but it's a wild world out there.
    if not client then
      return
    end

    on_dettach(client, args.buf)
  end,
})


-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = assert(vim.diagnostic.handlers.virtual_text.show)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2)
      return diag1.severity > diag2.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

local win_opts = {
  border = "rounded",
  max_height = math.floor(vim.o.lines * 0.5),
  max_width = math.floor(vim.o.columns * 0.4),
}

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover =
    function()
      hover(win_opts)
    end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help =
    function()
      signature_help(win_opts)
    end

local definition = vim.lsp.buf.definition
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.definition =
    function()
      local pos = vim.api.nvim_win_get_cursor(0)
      if pos ~= nil then
        vim.api.nvim_buf_set_mark(0, 'A', pos[1], pos[2], {})
      end
      definition()
    end


-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers['client/registerCapability']
vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end
  vim.print('Registering new capability for ' .. client.name)

  on_attach(client, vim.api.nvim_get_current_buf())

  return register_capability(err, res, ctx)
end

-- Set up LSP servers.
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    -- Extend neovim's client capabilities with the completion ones.
    local cmp_capabilities = require('blink.cmp').get_lsp_capabilities(nil, true);
    local capabilities = vim.tbl_deep_extend("force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_capabilities
    )
    capabilities.textDocument.onTypeFormatting = { dynamicRegistration = false }
    capabilities.textDocument.semanticTokens = { multilineTokenSupport = true }
    vim.lsp.config('*', {
      capabilities = capabilities,
      root_markers = { '.git' },
    })

    vim.lsp.enable(M.enable_lsp_severs)
  end,
})

-- HACK: Override buf_request to ignore notifications from LSP servers that don't implement a method.
local buf_request = vim.lsp.buf_request
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf_request = function(bufnr, method, params, handler)
  return buf_request(bufnr, method, params, handler, function() end)
end

return M
