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
      mappings = {
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-CR>'
        },
      }
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      local actions = require("CopilotChat.actions")
      local telescope = require("CopilotChat.integrations.telescope")

      chat.setup(opts)

      local mappings = {
        { mode = 'n', key = '<space>cce', action = "<cmd>CopilotChatExplain<cr>",                           desc = "CopilotChat - Explain code" },
        { mode = 'n', key = '<space>cct', action = "<cmd>CopilotChatTests<cr>",                             desc = "CopilotChat - Generate tests" },
        { mode = 'n', key = '<space>ccr', action = "<cmd>CopilotChatReview<cr>",                            desc = "CopilotChat - Review code" },
        { mode = 'n', key = '<space>ccR', action = "<cmd>CopilotChatRefactor<cr>",                          desc = "CopilotChat - Refactor code" },
        { mode = 'n', key = '<space>ccn', action = "<cmd>CopilotChatBetterNamings<cr>",                     desc = "CopilotChat - Better Naming" },
        { mode = 'n', key = '<space>ccp', action = function() telescope.pick(actions.prompt_actions()) end, desc = "CopilotChat - Prompt actions" },
        { mode = 'n', key = '<space>cct', action = chat.toggle,                                             desc = "CopilotChat - Toggle" },
        { mode = 'x', key = '<space>ccv', action = "<cmd>CopilotChatVisual<CR>",                            desc = "CopilotChat - Open in vertical split" },
        { mode = 'n', key = '<space>cch', action = function() telescope.pick(actions.help_actions()) end,   desc = "CopilotChat - Help actions" },
        { mode = 'n', key = '<space>ccm', action = "<cmd>CopilotChatCommit<cr>",                            desc = "CopilotChat - Generate commit message for all changes" },
        { mode = 'n', key = '<space>ccM', action = "<cmd>CopilotChatCommitStaged<cr>",                      desc = "CopilotChat - Generate commit message for staged changes" },
        {
          mode = 'x',
          key = '<space>ccp',
          action = function()
            telescope.pick(actions.prompt_actions({
              selection = opts
                  .selection
            }))
          end,
          desc = "CopilotChat - Prompt actions"
        },
        {
          mode = 'n',
          key = '<space>ccq',
          action = function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then vim.cmd("CopilotChatBuffer " .. input) end
          end,
          desc = "CopilotChat - Quick chat"
        },
      }

      for _, mapping in ipairs(mappings) do
        vim.keymap.set(mapping.mode, mapping.key, mapping.action, { silent = true, desc = mapping.desc })
      end
    end,
  },
}
