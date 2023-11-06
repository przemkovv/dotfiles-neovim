local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packages_install = function()
  local packer_bootstrap = ensure_packer()

  require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    --" Colorschemes {{{
    use 'romainl/Apprentice'
    use 'chriskempson/base16-vim'
    use 'ellisonleao/gruvbox.nvim'
    use 'bluz71/vim-moonfly-colors'
    use 'folke/tokyonight.nvim'
    --" }}}

    --" File navigation {{{
    use 'vim-scripts/FSwitch'
    use {
      'nvim-telescope/telescope.nvim', branch = '0.1.x',
      requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use "ahmedkhalf/project.nvim"

    use({
      "Maan2003/lsp_lines.nvim",
      -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
      end,
    })
    -- use {
    -- "vigoux/notifier.nvim"
    -- }

    use { 'nvim-telescope/telescope-fzf-native.nvim',
      run =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

    use 'onsails/lspkind.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use { 'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons
      },
      tag = 'nightly'                  -- optional, updated every week. (see issue #1193)
    }
    --" }}}

    -- " To sort {{{
    use 'mbbill/undotree'
    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
    }
    use 'tpope/vim-dispatch'
    -- use 'Shatur/neovim-tasks'
    use 'stevearc/overseer.nvim'
    use 'rcarriga/nvim-notify'
    use { 'mrded/nvim-lsp-notify' }
    use { "akinsho/toggleterm.nvim" }
    use { 'stevearc/dressing.nvim' }
    -- use 'radenling/vim-dispatch-neovim'
    use { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate" }
    use { 'nvim-treesitter/nvim-treesitter-textobjects' }
    use { 'nvim-treesitter/nvim-treesitter-context' }
    use "lukas-reineke/indent-blankline.nvim"
    use { 'm-demare/hlargs.nvim',
      requires = { 'nvim-treesitter/nvim-treesitter' }
    }

    vim.g.nremap = { ['<p'] = '', ['>p'] = '', ['<P'] = '', ['>P'] = '' }
    use 'tpope/vim-unimpaired'
    use { 'stsewd/sphinx.nvim', run = ":UpdateRemotePlugins" }


    use 'ciaranm/securemodelines'
    use 'mhinz/vim-signify'
    use 'MunifTanjim/exrc.nvim'

    use 'ryanoasis/vim-devicons'
    use 'scrooloose/nerdcommenter'
    use 'chrisbra/unicode.vim'

    -- " }}}
    -- " Status bar {{{
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use 'nvim-lua/lsp-status.nvim'
    -- " }}}

    -- " Search {{{
    -- use 'phaazon/hop.nvim'
    use 'ggandor/lightspeed.nvim'
    -- " }}}

    -- " Text Objects {{{
    use 'echasnovski/mini.nvim'
    use 'wellle/targets.vim'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use { 'jeetsukumaran/vim-pythonsense', ft = { 'python' } }
    use 'junegunn/vim-easy-align'
    -- " }}}

    -- Tags {{{
    use 'liuchengxu/vista.vim'
    -- }}}
    -- Completion {{{
    use 'p00f/clangd_extensions.nvim'
    use 'neovim/nvim-lspconfig'
    use 'jackguo380/vim-lsp-cxx-highlight'
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/vim-vsnip' }
    use { 'hrsh7th/vim-vsnip-integ' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use 'hrsh7th/cmp-cmdline'
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-nvim-lua' }
    use { 'hrsh7th/cmp-nvim-lsp-signature-help' }
    use { 'nvimdev/lspsaga.nvim'}

    use 'Shougo/context_filetype.vim'

    -- }}}
    -- " Snippets {{{
    use { 'rafamadriz/friendly-snippets' }
    -- " }}}

    -- " Dev Tools {{{
    use 'tpope/vim-fugitive'
    use 'gregsexton/gitv'
    use 'mattn/gist-vim'
    use 'mattn/webapi-vim'
    use 'Shougo/vinarise.vim'
    use 'diepm/vim-rest-console'
    use 'vim-scripts/DoxygenToolkit.vim'
    use 'norcalli/nvim-colorizer.lua'
    use { "johmsalas/text-case.nvim" }
    -- " }}}

    -- " Filetype specific {{{
    use { 'lervag/vimtex', ft = { 'tex' } }
    use { 'KeitaNakamura/tex-conceal.vim', ft = { 'tex' } }
    use 'wannesm/wmgraphviz.vim'
    use { 'chrisbra/csv.vim', ft = { 'csv' } }
    use { 'gennaro-tedesco/nvim-jqx', ft = { 'json', 'yaml' } }

    -- " HTML/CSS/Javascript/Typescript {{{
    use { 'tpope/vim-ragtag', ft = { 'html' } }
    use { 'othree/html5.vim', ft = { 'html' } }

    use { 'leafgarland/typescript-vim', ft = { 'typescript' } }
    -- " }}}
    -- " Haskell {{{
    use { 'neovimhaskell/haskell-vim', ft = { 'haskell' } }
    use { 'enomsg/vim-haskellConcealPlus', ft = { 'haskell' } }
    use { 'bitc/vim-hdevtools', ft = { 'haskell' } }
    -- " }}}
    -- " Rust {{{
    use { 'simrat39/rust-tools.nvim', ft = { 'rust' },
      config = function() require("rust-tools").setup({}) end
    }
    use { 'rust-lang/rust.vim', ft = { 'rust' } }
    -- " }}}
    -- " }}}
    -- Automatically vim.opt.up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end)

  return packer_bootstrap
end

return {
  install = packages_install
}
