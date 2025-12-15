return {

  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    lazy = true,
    cmd = "Telescope",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      "johmsalas/text-case.nvim",
      'nvim-telescope/telescope-symbols.nvim'
    },
    config = function()
      vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*" '
      vim.env.FZF_DEFAULT_OPTS = '--layout=reverse  --margin=1,2'

      local fzf_opts = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
      require('telescope').setup(
        {
          defaults = require('telescope.themes').get_ivy {
            -- Default configuration for telescope goes here:
            -- config_key = value,
            vimgrep_arguments =
            {
              "rg",
              "--color=never",
              "--no-heading",
              "--hidden",
              "--follow",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
              "--glob",
              "!.git/*",
            },
            mappings = {
              i = {
                ["<esc>"] = require('telescope.actions').close,
                ["<C-space>"] = require('telescope.actions.layout').toggle_preview,
              },
            },
            preview = {
              check_mime_type = true,
              hide_on_startup = false, -- hide previewer when picker starts
              filesize_limit = 0.4,
              highlight_limit = 0.05,
            },
            cache_picker = {
              num_pickers = 10,
            }
          },
          pickers = {
            -- Default configuration for builtin pickers goes here:
            find_files = {
              find_command = { "rg", "--files", "--hidden", "--follow", "--glob", "!.git/*" },
            },
            lsp_workspace_symbols = {
              fname_width = 120,
              symbol_width = 35,
              sorter = require('telescope').extensions.fzf.native_fzf_sorter(fzf_opts)
            },
            lsp_dynamic_workspace_symbols = {
              fname_width = 120,
              symbol_width = 35,
              sorter = require('telescope').extensions.fzf.native_fzf_sorter(fzf_opts)
            },
            live_grep = {
            },
            keymaps = {
              -- entry_maker = gen_from_keymaps,
            },
            grep_string = {
            },
            git_status = {
              git_icons = {
                added = "+",
                changed = "~",
                copied = ">",
                deleted = "-",
                renamed = "➡",
                unmerged = "‡",
                untracked = "?",
              },
            },
            buffers = {
              mappings = {
                i = { ["<c-d>"] = require('telescope.actions').delete_buffer
                },
              }
            },


            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
          },
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown {
                -- even more opts
              }
            },
            fzf = fzf_opts

          }
        })
      require('telescope').load_extension('fzf')
      require("telescope").load_extension('textcase')
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    lazy = true,
    build =
    'cmake -S. -Bbuild --preset ninja && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    "johmsalas/text-case.nvim",
    lazy = true,
    opts = {},
  },
}
