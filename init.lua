vim.loader.enable()

require('settings')
require('commands') -- TODO: make it lazy

-- NOTE: for vim-unimpaired
vim.g.nremap = { ['<p'] = '', ['>p'] = '', ['<P'] = '', ['>P'] = '' }

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require('packages').install()

require('colors').setup_colors()

require('keymaps')


-- " Filetype-specific ------------------------------------------------------- {{{

-- " Shaders {{{
vim.filetype.add({
  extension = {
    glsl = 'glsl',
    hlsl = 'hlsl',
    psh = 'hlsl',
    vsh = 'hlsl',
  }
})
-- }}}
-- " QuickFix {{{

vim.api.nvim_create_augroup("ft_quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_quickfix",
    pattern = "qf",
    callback = function()
      vim.cmd [[wincmd L]]
      -- vim.cmd [[resize 10]]
      vim.cmd [[setlocal colorcolumn=0 nolist nocursorline nowrap tw=0]]
    end
  })
-- " }}}
-- " Vim {{{
vim.api.nvim_create_augroup("ft_vim", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_vim",
    pattern = "vim",
    callback = function()
      vim.opt_local.foldmethod = "marker"
    end
  })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "ft_vim",
    pattern = "help",
    callback = function()
      vim.opt_local.textwidth = 78
    end
  })
vim.api.nvim_create_autocmd("BufWinEnter",
  {
    group = "ft_vim",
    pattern = "*.txt",
    callback = function()
      if vim.bo.filetype == 'help' then
        vim.cmd [[wincmd L]]
      end
    end
  })
-- " }}}

-- " }}}




-- " nvim-lsp {{{

-- require 'notifier'.setup {
-- -- You configuration here
-- }

-- Set up nvim-cmp.
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
-- capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
local capabilitiesClangd = vim.deepcopy(capabilities)
capabilitiesClangd.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.set_log_level("ERROR")

require 'lspconfig'.marksman.setup {
  capabilities = capabilities
}
-- require('lspconfig').rls.setup {
-- capabilities = capabilities
-- }
require('lspconfig').rust_analyzer.setup {
  capabilities = capabilities
}
require 'lspconfig'.glslls.setup {
  capabilities = capabilities
}
local clangd_attach_hints = function(client)
  -- require("clangd_extensions.inlay_hints").setup_autocmd()
  -- require("clangd_extensions.inlay_hints").set_inlay_hints()
end

local get_clangd_path = function()
  if vim.fn.has('windows') then
    return 'clangd'
  else
    return "/opt/clang/latest/bin/clangd"
  end
end
local get_clangd_query_driver = function()
  local drivers = {
    "clang-cl.exe",
    "clang++",
    "clang",
    "gcc",
    "g++",
    "arm-none-eabi-g++",
    "arm-none-eabi-gcc",
  }
  return "--query-driver=" .. table.concat(drivers, ",")
end
local original = vim.lsp.handlers['textDocument/publishDiagnostics']
vim.lsp.handlers['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
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
  original(_, result, ctx, config)
end

local function switch_source_header_splitcmd(bufnr, splitcmd)
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
    print 'textDocument/switchSourceHeader is not supported by the clangd server active on the current buffer'
  end
end
require("lspconfig").clangd.setup {
  cmd = {
    -- see clangd --help-hidden
    get_clangd_path(),
    -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
    -- to add more checks, create .clang-tidy file in the root directory
    -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
    "--background-index",
    "--background-index-priority=low",
    "--clang-tidy",
    "--pch-storage=memory",
    "--completion-style=bundled",
    "--header-insertion=iwyu",
    "--log=error",
    get_clangd_query_driver()
  },
  on_attach = clangd_attach_hints,
  init_options = {
    clangdFileStatus = true, -- Provides information about activity on clangd’s per-file worker thread
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
  commands = {
    ClangdSwitchSourceHeader = {
      function() switch_source_header_splitcmd(0, "edit") end,
      description = "Open source/header in current buffer",
    },
    ClangdSwitchSourceHeaderVSplit = {
      function() switch_source_header_splitcmd(0, "vsplit") end,
      description = "Open source/header in a new vsplit",
    },
    ClangdSwitchSourceHeaderSplit = {
      function() switch_source_header_splitcmd(0, "split") end,
      description = "Open source/header in a new split",
    }
  }
}
-- require('lspconfig').clangd.setup {
-- capabilities = capabilitiesClangd
-- }
require('lspconfig').pylsp.setup {
  capabilities = capabilities
}
require 'lspconfig'.esbonio.setup {
  capabilities = capabilities
}
require('lspconfig').vimls.setup {
  capabilities = capabilities
}
require('lspconfig').cmake.setup {
  capabilities = capabilities,
  init_options = {
    buildDirectory = "out/build/windows-msvc-debug",
    root_pattern = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake', 'out' }
  }
}
require 'lspconfig'.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime files
        library = {
          '${3rd}/luv/library',
          unpack(vim.api.nvim_get_runtime_file("", true)),
        },
      },
      completion = {
        callSnippet = 'Replace',
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- " lua require('lsp_settings').rust()
require 'lspconfig'.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { 'W391' },
          maxLineLength = 100
        }
      }
    }
  }
}
-- " lua require('lsp_settings').viml()

-- "
-- " }}}


vim.api.nvim_create_augroup("LspAttach_hlargs", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_hlargs",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local caps = client.server_capabilities
    if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
      require("hlargs").disable_buf(args.buf)
    end
  end,
})
vim.api.nvim_create_autocmd("LspDetach", {
  group = "LspAttach_hlargs",
  callback = function(args)
    require("hlargs").enable_buf(args.buf)
  end,
})

-- " }}}

-- vim.api.nvim_create_augroup("LspReferenceStyle", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- group = "LspReferenceStyle",
-- pattern = "*",
-- command =
-- vim.cmd [[
-- hi LspReferenceText gui=underline
-- hi LspReferenceRead gui=underline
-- hi LspReferenceWrite gui=underline
-- ]]
-- })


Signature_help_window_opened = false
Signature_help_forced = false
function My_signature_help_handler(handler)
  return function(...)
    if _G.Signature_help_forced and _G.Signature_help_window_opened then
      _G.Signature_help_forced = false
      return handler(...)
    end
    if _G.Signature_help_window_opened then
      return
    end
    local fbuf, fwin = handler(...)
    if fwin ~= nil then
      _G.Signature_help_window_opened = true
      vim.api.nvim_exec2("autocmd WinClosed " .. fwin .. " lua _G.signature_help_window_opened=false", { output = false })
    end
    return fbuf, fwin
  end
end

function Force_signature_help()
  _G.Signature_help_forced = true
  vim.lsp.buf.signature_help()
end


vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local bufopt = vim.bo[bufnr]

    local opts = { silent = true, buffer = bufnr }
    local opts2 = { silent = true }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil then
      if client.server_capabilities.completionProvider then
        bufopt.omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.server_capabilities.documentRangeFormattingProvider or client.server_capabilities.documentFormattingProvider then
        bufopt.formatexpr = 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})'
        vim.keymap.set('n', '<Space>=', "<cmd>lua vim.lsp.buf.format()<cr>", opts)
        vim.keymap.set('v', '<Space>=', "<cmd>lua vim.lsp.buf.format()<cr>", opts)
        vim.keymap.set('v', '<Space>gf', "<cmd>lua vim.lsp.formatexpr()<cr>", opts)
      end

      if client.server_capabilities.definitionProvider then
        bufopt.tagfunc = "v:lua.vim.lsp.tagfunc"
      end

      vim.keymap.set('n', '<space>sf', ':ClangdSwitchSourceHeader<CR>')
      vim.keymap.set('n', '<space>sF', ':ClangdSwitchSourceHeaderVSplit<CR>')
      vim.keymap.set('n', '<space>sd', vim.diagnostic.open_float)

      if client.server_capabilities.documentHighlightProvider then
        vim.opt.updatetime = 300
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("CursorHold", {
          callback = vim.lsp.buf.document_highlight,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
          callback = vim.lsp.buf.clear_references,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "Clear All the References",
        })
      end

      if client.server_capabilities.signatureHelpProvider then
        vim.api.nvim_create_augroup("lsp", { clear = true })
        vim.api.nvim_create_autocmd("CursorHoldI", {
          callback = vim.lsp.buf.signature_help,
          buffer = bufnr,
          group = "lsp",
        })
      end
      if client.server_capabilities.hoverProvider then
        vim.keymap.set('n', 'K', "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
      end
    end
    vim.keymap.set('n', '<Space>dc', "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set('n', '<space>gd', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<cr>',
      opts)
    vim.keymap.set('n', '<Space>gi', "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set('n', '<C-k>', Force_signature_help, opts)
    vim.keymap.set('i', '<C-k>', Force_signature_help, opts)
    vim.keymap.set('n', '<Space>k', "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set('n', '<Space>gt', "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", opts)
    vim.keymap.set('n', '<Space>gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", opts)
    vim.keymap.set('n', '<Space>gs', "<cmd>Lspsaga outline<cr>", opts)
    vim.keymap.set('n', '<Space>T', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", opts)
    vim.keymap.set('n', '<Space>t', "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>", opts2)
    vim.keymap.set('n', '<F12>', "<cmd>lua require('telescope.builtin').lsp_incoming_calls()<cr>", opts)
    vim.keymap.set('n', '<Space>ca', "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    vim.keymap.set('v', '<Space>ca', "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    vim.keymap.set('n', '<Space>cr', "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set("n", "[g", "<cmd>lua vim.diagnostic.goto_prev({float=false})<cr>", opts)
    vim.keymap.set("n", "]g", "<cmd>lua vim.diagnostic.goto_next({float=false})<cr>", opts)
    vim.keymap.set("n", "<space>dd", "<cmd>lua vim.diagnostic.setqflist()<cr>", opts)
    vim.keymap.set('n', '\\wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '\\wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '\\wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
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
        vim.keymap.del('n', '<Space>=', opts)
        vim.keymap.del('v', '<Space>=', opts)
      end
    end
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Do something with the client
    vim.cmd("setlocal tagfunc<")
    vim.cmd("set updatetime&")
  end,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "single"
  }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  My_signature_help_handler(vim.lsp.handlers.signature_help),
  {
    border = "single"
  }
)
require("lsp_lines").setup()

vim.keymap.set("n", "<space>L", require('utils').toggle_diagnostic_text, { desc = "Toggle lsp_lines" })

vim.keymap.set('n', '<space>l', ':ClangdToggleInlayHints<cr><c-l>', { silent = true })
-- telescope {{{


local opts = { remap = false }
vim.keymap.set('n', '<Space>r', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<Space>R', '<cmd>Telescope grep_string<CR>', opts)

vim.keymap.set('n', '<Space>gg', "<cmd>lua require('telescope.builtin').builtin()<cr>", opts)
vim.keymap.set('n', '<Space>?', '<cmd>Telescope help_tags<CR>', opts)
vim.keymap.set('n', '<Space>f', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<Space>F', '<cmd>Telescope git_files<CR>', opts)
vim.keymap.set('n', '<Space><c-F>', '<cmd>Telescope git_status<CR>', opts)
vim.keymap.set('n', '<Space>mr', '<cmd>Telescope oldfiles<CR>', opts)
vim.keymap.set('n', '<Space>mn', "<cmd>lua require('telescope.builtin').keymaps{modes={'n'}}<cr>", opts)
vim.keymap.set('n', '<Space>mx', "<cmd>lua require('telescope.builtin').keymaps{modes={'x'}}<cr>", opts)
vim.keymap.set('n', '<Space>mi', "<cmd>lua require('telescope.builtin').keymaps{modes={'i'}}<cr>", opts)
vim.keymap.set('n', '<Space>mo', "<cmd>lua require('telescope.builtin').keymaps{modes={'o'}}<cr>", opts)
vim.keymap.set('n', '<Space>mt', "<cmd>lua require('telescope.builtin').keymaps{modes={'t'}}<cr>", opts)
vim.keymap.set('n', '<Space>b', '<cmd>Telescope buffers<CR>', opts)
vim.keymap.set('n', '<Space>h', '<cmd>Telescope<CR>', opts)
-- vim.keymap.set('n', '<Space>T', '<cmd>Telescope current_buffer_tags<CR>', opts)
vim.keymap.set('n', '<Space>O', '<cmd>Telescope projects<CR>', opts)
vim.keymap.set('n', '<Space>o', '<cmd>OverseerToggle<CR>', opts)
vim.keymap.set('n', '<Space>a', '<cmd>ToggleTerm<CR>', opts)
vim.keymap.set('n', '\\c', '<cmd>Telescope colorscheme<CR>', opts)


-- }}}
--
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--
-- textcase {{{

vim.api.nvim_set_keymap('n', 'ga.', '<cmd>Telescope textcase<CR>', { desc = "Telescope" })
vim.api.nvim_set_keymap('v', 'ga.', "<cmd>Telescope textcase<CR>", { desc = "Telescope" })
-- vim.api.nvim_set_keymap('n', 'gaa', "<cmd>TextCaseOpenTelescopeQuickChange<CR>", { desc = "Telescope Quick Change" })
-- vim.api.nvim_set_keymap('n', 'gai', "<cmd>TextCaseOpenTelescopeLSPChange<CR>", { desc = "Telescope LSP Change" })

-- }}}
