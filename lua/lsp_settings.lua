---@class lsp.ClientCapabilities
local cmp_capabilities = {}
if package.loaded["blink.cmp"] then
  cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
elseif package.loaded["cmp_nvim_lsp"] then
  cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
end

---@class lsp.ClientCapabilities
local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  cmp_capabilities
)

capabilities.textDocument.onTypeFormatting = { dynamicRegistration = false }
capabilities.offsetEncoding = { "utf-16" }
capabilities.textDocument.semanticTokens = { multilineTokenSupport = true }

vim.lsp.inline_completion.enable(true)
vim.lsp.on_type_formatting.enable(true)
vim.lsp.semantic_tokens.enable(true)

vim.lsp.config('*', {
  capabilities = capabilities,
  root_markers = { '.git' },
})


vim.lsp.enable('marksman')
vim.lsp.enable('glslls')
vim.lsp.enable('clangd')
vim.lsp.enable('pylsp')
vim.lsp.enable('jsonls')
vim.lsp.enable('esbonio')
vim.lsp.enable('vimls')
vim.lsp.enable('slangd')
-- vim.lsp.enable('cmake')
vim.lsp.enable('lua_ls')
vim.lsp.enable('roslyn')
-- vim.lsp.enable('roslyn_ls')
vim.lsp.enable('lemminx')
vim.lsp.enable('powershell_es')
vim.lsp.enable('copilot')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('dockerls')

vim.lsp.handlers['textDocument/publishDiagnostics'] = require('lsp_utils').on_publish_diagnostics_with_related(vim.lsp
  .handlers['textDocument/publishDiagnostics'])

vim.keymap.set('i', '<Tab>', function()
  if not vim.lsp.inline_completion.get() then
    return '<Tab>'
  end
end, { expr = true, desc = 'Accept the current inline completion' })

vim.keymap.set('i', '<c-.>', function()
  vim.lsp.inline_completion.select({ count = 1 })
end, { expr = true, desc = 'Next suggestion' })
vim.keymap.set('i', '<c-,>', function()
  vim.lsp.inline_completion.select({ count = -1 })
end, { expr = true, desc = 'Prev suggestion' })

-- " nvim-lsp {{{
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf

    local opts = { silent = true, buffer = bufnr }
    local opts2 = { silent = true }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil then
      if client.server_capabilities.completionProvider then
        -- bufopt.omnifunc = "v:lua.vim.lsp.omnifunc"
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
      end
      if client.server_capabilities.documentRangeFormattingProvider or client.server_capabilities.documentFormattingProvider then
        vim.keymap.set('v', '<Space>gf', vim.lsp.formatexpr, opts)
      end

      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(false)
      end

      if client:supports_method('textDocument/foldingRange') then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end

      if client.name == 'clangd' then
        vim.keymap.set('n', '<space>sf', ':ClangdSwitchSourceHeader<CR>')
        vim.keymap.set('n', '<space>sF', ':ClangdSwitchSourceHeaderVSplit<CR>')
      end

      if client.server_capabilities.hoverProvider then
        vim.keymap.set('n', 'K', require('lsp_utils').hover, opts)
      end
      if client.server_capabilities.inlayHintProvider then
        vim.keymap.set('n', '<space>l', require('utils').toggle_inlay_hints, opts)
      end
    end
    vim.keymap.set('n', '<Space>gd', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', require('lsp_utils').definition, opts)
    vim.keymap.set('n', 'gD', function() require "telescope.builtin".lsp_definitions({ jump_type = "vsplit" }) end,
      opts)
    vim.keymap.set('n', '<C-k>', require('lsp_utils').signature_help, opts)
    vim.keymap.set('i', '<C-k>', require('lsp_utils').signature_help, opts)
    vim.keymap.set('n', '<Space>gt', require('telescope.builtin').lsp_type_definitions, opts)
    vim.keymap.set('n', '<Space>gr', require('telescope.builtin').lsp_references, opts)
    vim.keymap.set('n', '<Space>gs', "<cmd>Lspsaga outline<cr>", opts)
    vim.keymap.set('n', '<Space>gp', "<cmd>Lspsaga peek_definition<cr>", opts)
    vim.keymap.set('n', '<Space>T', require('telescope.builtin').lsp_document_symbols, opts)
    -- vim.keymap.set('n', '<Space>t', require('telescope.builtin').lsp_dynamic_workspace_symbols, opts2)
    vim.keymap.set('n', '<Space>t', require('telescope.builtin').lsp_workspace_symbols, opts2)
    vim.keymap.set('n', '<space>ic', require('telescope.builtin').lsp_incoming_calls, opts)
    vim.keymap.set("n", "<space>dd", vim.diagnostic.setqflist, opts)
    vim.keymap.set('n', '\\wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '\\wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '\\wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  ---@diagnostic disable-next-line: unused-local
  callback = function(args)
    local bufnr = args.buf
    local opts = { silent = true, buffer = bufnr }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil then
      if client.server_capabilities.documentRangeFormattingProvider or client.server_capabilities.documentFormattingProvider then
        vim.keymap.del('v', '<Space>gf', opts)
      end
    end
    local lsp_document_highlight_id = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = lsp_document_highlight_id }
    local signature_help_id = vim.api.nvim_create_augroup("lsp_signature_help", { clear = false })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = signature_help_id }

    vim.cmd("set updatetime&")
  end,
})

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
-- " }}}
