return {
  cmd = { "slangd" },
  filetypes = { 'hlsl', 'shaderslang' },
  root_markers = { '.git' },
  single_file_support = true,
  settings = {
    slangLanguageServer = {
      trace = {
        -- server = "messages"
      },
    },
    slang = {
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
