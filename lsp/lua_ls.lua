---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      format = {
        enable = true,
        default_config = {
          indent_style = "space",
          indent_size = 2,
          max_line_length = 120,
          trim_trailing_whitespace = true,
          insert_final_newline = true,
        },
      },
      workspace = {
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime files
        library = vim.list.unique(vim.iter({
          vim.fn.expand('$VIMRUNTIME/lua'),
          vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
          '${3rd}/luv/library',
          '${3rd}/busted/library',
          vim.api.nvim_get_runtime_file("lua", true),
        }):flatten():totable()),
      },
      completion = {
        callSnippet = 'Replace',
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    }
  }
}
