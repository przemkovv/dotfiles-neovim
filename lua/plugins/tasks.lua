---@type LazySpec
return {
  'tpope/vim-dispatch',
  {
    'stevearc/overseer.nvim',
    lazy = true,
    cmd = "OverseerToggle",
    opts = {
      templates = { "builtin", "command_runner", "run_ctest" },
      task_list = {
        direction = "right",
        max_width = { 300, 0.3 },
      }
    },
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = { "ToggleTerm", "TermSelect" },
    opts = {
      direction = "vertical",
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end
    }
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
      "nsidorenco/neotest-vstest"
    },
    config = function()
      require("neotest").setup({
        summary = {
          open = "botright vsplit | vertical resize 90"
        },
        adapters = {
          require("neotest-vitest") {
            vitestCommand = "pnpm exec vitest",
            filter_dir = function(name, rel_path, root)
              local full_path = root .. "/" .. rel_path

              if root:match("projects/pocketecg-nextgen") then
                if full_path:match("^__tests__") then
                  return true
                else
                  return false
                end
              else
                return name ~= "node_modules"
              end
            end,
          },
          -- require("neotest-vstest"),
        },
      })
    end,
    keys = {
      {
        "<localleader>twr",
        "<cmd>lua require('neotest').run.run({ vitestCommand = 'pnpm exec vitest --watch' })<cr>",
        desc = "Run Watch"
      },
      {
        "<localleader>twf",
        "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), vitestCommand = 'pnpm exec vitest --watch' })<cr>",
        desc = "Run Watch File"
      },
      {
        "<localleader>ts",
        function() require("neotest").summary.toggle() end,
        desc = "Toggle Test Summary"
      },
      {
        "<localleader>tf",
        function() require("neotest").run.run(vim.fn.expand("%")) end,
        desc = "Run Test File"
      },
      {
        "<localleader>tl",
        function() require("neotest").run.run_last() end,
        desc = "Run Last Test"
      },
      {
        "<localleader>tn",
        function() require("neotest").run.run() end,
        desc = "Run Nearest Test"
      },
      {
        "<localleader>to",
        function() require("neotest").output.open({ enter = true }) end,
        desc = "Open Test Output"
      },
      {
        "<localleader>tS",
        function() require("neotest").run.stop() end,
        desc = "Stop Test"
      },
    }
  }
}
