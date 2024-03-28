local prompts = {
  -- Code related prompts
  Explain = { prompt = "Please explain how the following code works.", },
  Review = { prompt = "Please review the following code and provide suggestions for improvement.", },
  Tests = { prompt = "Please explain how the selected code works, then generate unit tests for it.", },
  Refactor = { prompt = "Please refactor the following code to improve its clarity and readability.", },
  FixCode = { prompt = "Please fix the following code to make it work as intended.", },
  FixError = { prompt = "Please explain the error in the following text and provide a solution.", },
  BetterNamings = { prompt = "Please provide better names for the following variables and functions.", },
  Documentation = { prompt = "Please provide documentation for the following code.", },
  SwaggerApiDocs = { prompt = "Please provide documentation for the following API using Swagger.", },
  SwaggerJsDocs = { prompt = "Please write JSDoc for the following API using Swagger.", },
  -- Text related prompts
  Summarize = { prompt = "Please summarize the following text.", },
  Spelling = { prompt = "Please correct any grammar and spelling errors in the following text.", },
  Wording = { prompt = "Please improve the grammar and wording of the following text.", },
  Concise = { prompt = "Please rewrite the following text to make it more concise.", },
}

return {
  {
    enabled = true,

    "github/copilot.vim",
    config = function()
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },    -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      -- prompts = prompts,
      -- default selection (visual or line)
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.line(source)
      end,
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      require("CopilotChat").setup(opts)
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })

      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })

      vim.keymap.set('n', '<space>ccp', function()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
      end, { silent = true, desc = "CopilotChat - Prompt actions" })

      vim.keymap.set({ 'x' }, '<space>ccp', function()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions({
          selection = require('CopilotChat.select').visual
        }))
      end, { silent = true, desc = "CopilotChat - Prompt actions" })

      vim.keymap.set({ 'x' }, '<space>ccv', "<cmd>CopilotChatVisual<CR>",
        { silent = true, desc = "CopilotChat - Open in vertical split" })
    end,
    keys = {
      -- Show help actions with telescope
      {
        "<space>cch",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Generate commit message based on the git diff
      {
        "<space>ccm",
        "<cmd>CopilotChatCommit<cr>",
        desc = "CopilotChat - Generate commit message for all changes",
      },
      {
        "<space>ccM",
        "<cmd>CopilotChatCommitStaged<cr>",
        desc = "CopilotChat - Generate commit message for staged changes",
      },
      -- Quick chat with Copilot
      {
        "<space>ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      -- Code related commands
      { "<space>cce", "<cmd>CopilotChatExplain<cr>",       desc = "CopilotChat - Explain code" },
      { "<space>cct", "<cmd>CopilotChatTests<cr>",         desc = "CopilotChat - Generate tests" },
      { "<space>ccr", "<cmd>CopilotChatReview<cr>",        desc = "CopilotChat - Review code" },
      { "<space>ccR", "<cmd>CopilotChatRefactor<cr>",      desc = "CopilotChat - Refactor code" },
      { "<space>ccn", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
    }
  },
}
