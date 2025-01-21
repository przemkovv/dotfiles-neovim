local cmp_capabilities = nil
if package.loaded["blink.cmp"] then
  cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
else
  cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
end

local capabilities = vim.tbl_deep_extend("force",
  vim.lsp.protocol.make_client_capabilities(),
  cmp_capabilities
)

capabilities.offsetEncoding = { "utf-16" }

-- local capabilitiesClangd = vim.deepcopy(capabilities)
-- capabilitiesClangd.textDocument.completion.completionItem.snippetSupport = true
--
require 'lspconfig'.marksman.setup {
  capabilities = capabilities
}
-- require('lspconfig').rls.setup {
-- capabilities = capabilities
-- }
require('lspconfig').rust_analyzer.setup {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
        features = "all",
      },
      check = {
        command = "clippy",
        -- features = "all",
        -- extraArgs = {  "--all-features", "--all-targets", },
      },
      checkOnSave = true,
      completion = {
        postfix = {
          enable = true,
        },
        autoimport = {
          enable = true
        },
      },
      diagnostics = {
        enable = true,
        enableExperimental = true,
      },
      procMacro = {
        enable = true
      },
      assist = {
        emitMustUse = true
      },
      inlayHints = {
        chainingHints = true,
        parameterHints = true,
        typeHints = true,
      },
      workspace = {
        symbol = {
          search = {
            kind = "all_symbols"
          }
        }
      }
    }
  }
}
require 'lspconfig'.glslls.setup {
  capabilities = capabilities
}

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


require("lspconfig").clangd.setup {
  capabilities = capabilities,
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
  init_options = {
    clangdFileStatus = true, -- Provides information about activity on clangd’s per-file worker thread
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
  commands = {
    ClangdSwitchSourceHeader = {
      function() require('lsp_utils').switch_source_header_splitcmd(0, "edit") end,
      description = "Open source/header in current buffer",
    },
    ClangdSwitchSourceHeaderVSplit = {
      function() require('lsp_utils').switch_source_header_splitcmd(0, "vsplit") end,
      description = "Open source/header in a new vsplit",
    },
    ClangdSwitchSourceHeaderSplit = {
      function() require('lsp_utils').switch_source_header_splitcmd(0, "split") end,
      description = "Open source/header in a new split",
    }
  }
}

require('lspconfig').pylsp.setup {
  capabilities = capabilities
}
require('lspconfig').jsonls.setup {
  capabilities = capabilities
}
require 'lspconfig'.esbonio.setup {
  capabilities = capabilities
}
require('lspconfig').vimls.setup {
  capabilities = capabilities
}
require('lspconfig').slangd.setup {
  capabilities = capabilities,
  cmd = {
    "slangd"
  },
  root_dir = function(fname)
    return require('lspconfig').util.find_git_ancestor(fname)
  end,
  settings = {
    slangLanguageServer = {
      trace = {
        -- server = "messages"
      },
    },
    slang = {
      additionalSearchPaths = { "H:/Projects/robotron/software/endorobot_app/src/shaders/common", },
      format = {
        -- clangFormatStyle = "file",
      },
      inlayHints = {
        deducedTypes = true,
        parameterNames = true,
      }
    }
  }
}

local get_build_dir = function()
  local build_dir = "build/"
  if vim.g.build_dir ~= nil then
    build_dir = vim.g.build_dir
  end
  return build_dir
end

require('lspconfig').cmake.setup {
  capabilities = capabilities,
  init_options = {
    buildDirectory = get_build_dir(),
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
          '${3rd}/busted/library',
          vim.api.nvim_get_runtime_file("", true),
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

vim.lsp.handlers['textDocument/publishDiagnostics'] = require('lsp_utils').on_publish_diagnostics_with_related(vim.lsp
  .handlers['textDocument/publishDiagnostics'])

-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
--   vim.lsp.handlers.hover, {
--     border = "single"
--   }
-- )
-- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
--   require('lsp_utils').My_signature_help_handler(vim.lsp.handlers.signature_help),
--   {
--     border = "single"
--   }
-- )


-- " hlargs {{{

-- local hlargs_group_id = vim.api.nvim_create_augroup("LspAttach_hlargs", { clear = true })
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = hlargs_group_id,
--   callback = function(args)
--     if not (args.data and args.data.client_id) then
--       return
--     end
--
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client == nil then
--       return
--     end
--     local caps = client.server_capabilities
--     if caps
--         and caps.semanticTokensProvider
--         and caps.semanticTokensProvider.full then
--       require("hlargs").disable_buf(args.buf)
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd("LspDetach", {
--   group = hlargs_group_id,
--   callback = function(args)
--     require("hlargs").enable_buf(args.buf)
--   end,
-- })

-- " }}}

-- " nvim-lsp {{{
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
        vim.keymap.set('n', '<Space>=', vim.lsp.buf.format, opts)
        vim.keymap.set('v', '<Space>=', vim.lsp.buf.format, opts)
        vim.keymap.set('v', '<Space>gf', vim.lsp.formatexpr, opts)
      end

      if client:supports_method('textDocument/foldingRange') then
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end
      if client.server_capabilities.definitionProvider then
        bufopt.tagfunc = "v:lua.vim.lsp.tagfunc"
      end

      if client.name == 'clangd' then
        vim.keymap.set('n', '<space>sf', ':ClangdSwitchSourceHeader<CR>')
        vim.keymap.set('n', '<space>sF', ':ClangdSwitchSourceHeaderVSplit<CR>')
      end

      -- if client.server_capabilities.documentHighlightProvider then
      --   vim.opt.updatetime = 300
      --   local lsp_document_highlight_id = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      --   vim.api.nvim_create_autocmd(
      --     { "CursorHold", "CursorHoldI" },
      --     {
      --       callback = vim.lsp.buf.document_highlight,
      --       buffer = bufnr,
      --       group = lsp_document_highlight_id,
      --       desc = "Document Highlight",
      --     })
      --   vim.api.nvim_create_autocmd("CursorMoved", {
      --     callback = vim.lsp.buf.clear_references,
      --     buffer = bufnr,
      --     group = lsp_document_highlight_id,
      --     desc = "Clear All the References",
      --   })
      -- end

      if client.server_capabilities.hoverProvider then
        vim.keymap.set('n', 'K', require('lsp_utils').hover, opts)
      end
      if client.server_capabilities.inlayHintProvider then
        vim.keymap.set('n', '<space>l', require('utils').toggle_inlay_hints, opts)
      end
    end
    vim.keymap.set('n', '<Space>gd', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gd', require('lsp_utils').definition, opts)
    vim.keymap.set('n', 'gD', function() require "telescope.builtin".lsp_definitions({ jump_type = "vsplit" }) end,
      opts)
    vim.keymap.set('n', '<Space>gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', require('lsp_utils').signature_help, opts)
    vim.keymap.set('i', '<C-k>', require('lsp_utils').signature_help, opts)
    vim.keymap.set('n', '<Space>gt', require('telescope.builtin').lsp_type_definitions, opts)
    vim.keymap.set('n', '<Space>gr', require('telescope.builtin').lsp_references, opts)
    vim.keymap.set('n', '<Space>gs', "<cmd>Lspsaga outline<cr>", opts)
    vim.keymap.set('n', '<Space>T', require('telescope.builtin').lsp_document_symbols, opts)
    vim.keymap.set('n', '<Space>t', require('telescope.builtin').lsp_dynamic_workspace_symbols, opts2)
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
        vim.keymap.del('n', '<Space>=', opts)
        vim.keymap.del('v', '<Space>=', opts)
      end
    end
    local lsp_document_highlight_id = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = lsp_document_highlight_id }
    local signature_help_id = vim.api.nvim_create_augroup("lsp_signature_help", { clear = false })
    vim.api.nvim_clear_autocmds { buffer = bufnr, group = signature_help_id }

    vim.cmd("setlocal tagfunc<")
    vim.cmd("set updatetime&")
  end,
})
-- " }}}
