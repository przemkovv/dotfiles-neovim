return {
  {
    "mason-org/mason.nvim",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = {
        "marksman",
        -- "glslls",
        "clangd",
        "gersemi",
        "python-lsp-server",
        "json-lsp",
        "esbonio",
        "vim-language-server",
        "slang",
        -- "lua-language-server",
        "roslyn",
        "lemminx",
        "powershell-editor-services",
        "copilot-language-server",
        "rust-analyzer",
        'remark-language-server',
        "cmake-language-server",
        "cmakelang",
        "cmakelint",
        "dockerfile-language-server",
        "jq",
        "jq-lsp",
        "typescript-language-server"
      },

    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mason_registry = require("mason-registry")
      local function install_mason_package(name)
        local package = mason_registry.get_package(name)
        if not package:is_installed() then
          package:install()
        end
      end
      for _, name in ipairs(opts.ensure_installed) do
        install_mason_package(name)
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "marksman",
        -- "glslls",
        "clangd",
        "pylsp",
        "jsonls",
        "esbonio",
        "vimls",
        "slangd",
        -- "lua_ls",
        "lemminx",
        "powershell_es",
        "copilot",
        "rust_analyzer",
        "cmake",
        "dockerls",
        "jqls",
        "ts_ls"
      },
      automatic_enable = false,
    },
  },
}
