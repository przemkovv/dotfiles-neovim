-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/przemkovv/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/przemkovv/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/przemkovv/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/przemkovv/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/przemkovv/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  Apprentice = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/Apprentice",
    url = "https://github.com/romainl/Apprentice"
  },
  ["DoxygenToolkit.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/DoxygenToolkit.vim",
    url = "https://github.com/vim-scripts/DoxygenToolkit.vim"
  },
  FSwitch = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/FSwitch",
    url = "https://github.com/vim-scripts/FSwitch"
  },
  ["base16-vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/base16-vim",
    url = "https://github.com/chriskempson/base16-vim"
  },
  ["context_filetype.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/context_filetype.vim",
    url = "https://github.com/Shougo/context_filetype.vim"
  },
  ["csv.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/csv.vim",
    url = "https://github.com/chrisbra/csv.vim"
  },
  ["deoplete-lsp"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/deoplete-lsp",
    url = "https://github.com/Shougo/deoplete-lsp"
  },
  ["deoplete-typescript"] = {
    after_files = { "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/deoplete-typescript/after/plugin/nvim_typescript.vim" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/deoplete-typescript",
    url = "https://github.com/mhartington/deoplete-typescript"
  },
  ["deoplete.nvim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/deoplete.nvim",
    url = "https://github.com/Shougo/deoplete.nvim"
  },
  ["echodoc.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/echodoc.vim",
    url = "https://github.com/Shougo/echodoc.vim"
  },
  fzf = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gist-vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/gist-vim",
    url = "https://github.com/mattn/gist-vim"
  },
  gitv = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/gitv",
    url = "https://github.com/gregsexton/gitv"
  },
  ["haskell-vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/haskell-vim",
    url = "https://github.com/neovimhaskell/haskell-vim"
  },
  ["html5.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/html5.vim",
    url = "https://github.com/othree/html5.vim"
  },
  ["neco-ghc"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/neco-ghc",
    url = "https://github.com/eagletmt/neco-ghc"
  },
  neoformat = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/neoformat",
    url = "https://github.com/sbdchd/neoformat"
  },
  ["neosnippet.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/neosnippet.vim",
    url = "https://github.com/Shougo/neosnippet.vim"
  },
  nerdcommenter = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/nerdcommenter",
    url = "https://github.com/scrooloose/nerdcommenter"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["rust.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/rust.vim",
    url = "https://github.com/rust-lang/rust.vim"
  },
  securemodelines = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/securemodelines",
    url = "https://github.com/ciaranm/securemodelines"
  },
  tagbar = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/tagbar",
    url = "https://github.com/majutsushi/tagbar"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["tex-conceal.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/tex-conceal.vim",
    url = "https://github.com/KeitaNakamura/tex-conceal.vim"
  },
  ["typescript-vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/typescript-vim",
    url = "https://github.com/leafgarland/typescript-vim"
  },
  undotree = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["unicode.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/unicode.vim",
    url = "https://github.com/chrisbra/unicode.vim"
  },
  ["vim-airline"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-airline",
    url = "https://github.com/vim-airline/vim-airline"
  },
  ["vim-cpp"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/vim-cpp",
    url = "https://github.com/vim-jp/vim-cpp"
  },
  ["vim-cpp-enhanced-highlight"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/vim-cpp-enhanced-highlight",
    url = "https://github.com/octol/vim-cpp-enhanced-highlight"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-dispatch",
    url = "https://github.com/tpope/vim-dispatch"
  },
  ["vim-dispatch-neovim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-dispatch-neovim",
    url = "https://github.com/radenling/vim-dispatch-neovim"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-haskellConcealPlus"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/vim-haskellConcealPlus",
    url = "https://github.com/enomsg/vim-haskellConcealPlus"
  },
  ["vim-hdevtools"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/vim-hdevtools",
    url = "https://github.com/bitc/vim-hdevtools"
  },
  ["vim-localvimrc"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-localvimrc",
    url = "https://github.com/embear/vim-localvimrc"
  },
  ["vim-lsp-cxx-highlight"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-lsp-cxx-highlight",
    url = "https://github.com/jackguo380/vim-lsp-cxx-highlight"
  },
  ["vim-pandoc-syntax"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/vim-pandoc-syntax",
    url = "https://github.com/vim-pandoc/vim-pandoc-syntax"
  },
  ["vim-pythonsense"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/vim-pythonsense",
    url = "https://github.com/jeetsukumaran/vim-pythonsense"
  },
  ["vim-ragtag"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/vim-ragtag",
    url = "https://github.com/tpope/vim-ragtag"
  },
  ["vim-raml"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-raml",
    url = "https://github.com/IN3D/vim-raml"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-rest-console"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-rest-console",
    url = "https://github.com/diepm/vim-rest-console"
  },
  ["vim-signify"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-signify",
    url = "https://github.com/mhinz/vim-signify"
  },
  ["vim-sneak"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-sneak",
    url = "https://github.com/justinmk/vim-sneak"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-textobj-fold"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-textobj-fold",
    url = "https://github.com/kana/vim-textobj-fold"
  },
  ["vim-textobj-function"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-textobj-function",
    url = "https://github.com/kana/vim-textobj-function"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-textobj-user",
    url = "https://github.com/kana/vim-textobj-user"
  },
  ["vim-trailing-whitespace"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-trailing-whitespace",
    url = "https://github.com/bronson/vim-trailing-whitespace"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  vimtex = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex",
    url = "https://github.com/lervag/vimtex"
  },
  ["vinarise.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/vinarise.vim",
    url = "https://github.com/Shougo/vinarise.vim"
  },
  ["webapi-vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/webapi-vim",
    url = "https://github.com/mattn/webapi-vim"
  },
  ["wmgraphviz.vim"] = {
    loaded = true,
    path = "/home/przemkovv/.local/share/nvim/site/pack/packer/start/wmgraphviz.vim",
    url = "https://github.com/wannesm/wmgraphviz.vim"
  }
}

time([[Defining packer_plugins]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType cpp ++once lua require("packer.load")({'vim-cpp', 'vim-cpp-enhanced-highlight'}, { ft = "cpp" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'vim-pythonsense'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType csv ++once lua require("packer.load")({'csv.vim'}, { ft = "csv" }, _G.packer_plugins)]]
vim.cmd [[au FileType haskell ++once lua require("packer.load")({'vim-haskellConcealPlus', 'haskell-vim', 'vim-hdevtools'}, { ft = "haskell" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'vim-ragtag', 'html5.vim'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'vim-pandoc-syntax'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType tex ++once lua require("packer.load")({'vimtex', 'tex-conceal.vim'}, { ft = "tex" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescript ++once lua require("packer.load")({'typescript-vim', 'deoplete-typescript'}, { ft = "typescript" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]], true)
vim.cmd [[source /home/przemkovv/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]]
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]], false)
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/typescript-vim/ftdetect/typescript.vim]], true)
vim.cmd [[source /home/przemkovv/.local/share/nvim/site/pack/packer/opt/typescript-vim/ftdetect/typescript.vim]]
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/typescript-vim/ftdetect/typescript.vim]], false)
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/haskell-vim/ftdetect/haskell.vim]], true)
vim.cmd [[source /home/przemkovv/.local/share/nvim/site/pack/packer/opt/haskell-vim/ftdetect/haskell.vim]]
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/haskell-vim/ftdetect/haskell.vim]], false)
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]], true)
vim.cmd [[source /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]]
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]], false)
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], true)
vim.cmd [[source /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]]
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], false)
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]], true)
vim.cmd [[source /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]]
time([[Sourcing ftdetect script at: /home/przemkovv/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
