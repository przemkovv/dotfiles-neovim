return {

  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    lazy = true,
    cmd = "Telescope",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      "johmsalas/text-case.nvim",
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
                ["<c-t>"] = require('trouble.sources.telescope').open,
              },
              n = { ["<c-t>"] = require('trouble.sources.telescope').open },
            },
            preview = {
              hide_on_startup = true -- hide previewer when picker starts
            }
          },
          pickers = {
            -- Default configuration for builtin pickers goes here:
            find_files = {
              find_command = { "rg", "--files", "--hidden", "--follow", "--glob", "!.git/*" },
            },
            lsp_dynamic_workspace_symbols = {
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

              -- pseudo code / specification for writing custom displays, like the one
              -- for "codeactions"
              -- specific_opts = {
              --   [kind] = {
              --     make_indexed = function(items) -> indexed_items, width,
              --     make_displayer = function(widths) -> displayer
              --     make_display = function(displayer) -> function(e)
              --     make_ordinal = function(e) -> string
              --   },
              --   -- for example to disable the custom builtin "codeactions" display
              --      do the following
              --   codeactions = false,
              -- }
            },
            fzf = fzf_opts

          }
        })
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('projects')
      require("telescope").load_extension('textcase')
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    lazy = true,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    lazy = true,
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    "johmsalas/text-case.nvim",
    lazy = true,
    opts = {},
  },
}
