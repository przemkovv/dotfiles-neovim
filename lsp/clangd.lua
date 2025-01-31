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

return {
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
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  single_file_support = true,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
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
