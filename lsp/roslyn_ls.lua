
---@param client vim.lsp.Client
---@param target string
local function on_init_sln(client, target)
  vim.notify('Initializing: ' .. target, vim.log.levels.INFO, { title = 'roslyn_ls' })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify('solution/open', {
    solution = vim.uri_from_fname(target),
  })
end

---@type vim.lsp.ClientConfig
return {
  cmd = {
    "dotnet",
    "C:/Users/pwalkowiak/.vscode/extensions/ms-dotnettools.csharp-2.84.19-win32-x64/.roslyn/Microsoft.CodeAnalysis.LanguageServer.dll",
    "--logLevel=Information",
    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
    "--stdio",
  },
  on_init = {
    function(client)
      local root_dir = client.config.root_dir
      local files = vim.fs.find(function(name, path)
        return name:match('.*%.sln$')
      end, { limit = math.huge, type = 'file', path = root_dir })

      vim.ui.select(files, {
        prompt = 'Select solution file:',
        format_item = function(item)
          return item
        end,
      }, function(choice)
        if choice == nil then
          vim.notify('No solution file selected', vim.log.levels.WARN, { title = 'roslyn_ls' })
          return
        end
        on_init_sln(client, choice)
      end)
    end,
  },
}
