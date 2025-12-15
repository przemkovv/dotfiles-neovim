local get_nvim_libraries = function()
  local nvim_libraries =
      vim.tbl_map(vim.fs.normalize,
        vim.list.unique(vim.iter({
          -- vim.fn.expand('$VIMRUNTIME/lua'),
          -- vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
          vim.api.nvim_get_runtime_file("", true),
        }):flatten():totable()))

  local config_dir = vim.fs.normalize(vim.fn.stdpath('config'))
  nvim_libraries = vim.tbl_filter(function(path)
    return path ~= config_dir
  end, nvim_libraries)
end

local get_wezterm_libraries = function()
  return vim.api.nvim_get_runtime_file("lua/wezterm/types", true)
end

local get_libraries = function(root_dir)
  vim.print("Getting libraries for root dir: " .. root_dir)
  if root_dir == vim.fn.stdpath('config') then
    return get_nvim_libraries()
  end
  if root_dir:find('wezterm') then
    return get_wezterm_libraries()
  end
  return {}
end


---@type vim.lsp.Config
return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = get_libraries(client.workspace_folders[1].name),
      }
    })
  end,

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
