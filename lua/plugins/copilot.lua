
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = true,
    event = "VeryLazy",
    branch = "main",
    dependencies = {
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    -- build = "make tiktoken",
    opts = {
      -- model = 'gpt-5',
      debug = false, -- Enable debugging
      -- prompts = prompts,
      mappings = {
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-CR>'
        },
      },
      window = {
        border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
        title = '🤖 AI Assistant',
        zindex = 100,       -- Ensure window stays on top
      },

      headers = {
        user = '👤 You',
        assistant = '🤖 Copilot',
        tool = '🔧 Tool',
      },

      separator = '━━',
      auto_fold = true, -- Automatically folds non-assistant messages
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      chat.setup(opts)

      local mappings = {
        { mode = 'n', key = '<space>cce', action = "<cmd>CopilotChatExplain<cr>",       desc = "CopilotChat - Explain code" },
        { mode = 'x', key = '<space>ccT', action = "<cmd>CopilotChatTests<cr>",         desc = "CopilotChat - Generate tests" },
        { mode = 'n', key = '<space>ccr', action = "<cmd>CopilotChatReview<cr>",        desc = "CopilotChat - Review code" },
        { mode = 'n', key = '<space>ccR', action = "<cmd>CopilotChatRefactor<cr>",      desc = "CopilotChat - Refactor code" },
        { mode = 'n', key = '<space>ccn', action = "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
        { mode = 'n', key = '<space>ccp', action = "<cmd>CopilotChatPrompts<cr>",       desc = "CopilotChat - Prompt actions" },
        { mode = 'n', key = '<space>cct', action = "<cmd>CopilotChatToggle<cr>",        desc = "CopilotChat - Toggle" },
        { mode = 'x', key = '<space>ccv', action = "<cmd>CopilotChatVisual<CR>",        desc = "CopilotChat - Open in vertical split" },
        { mode = 'n', key = '<space>ccm', action = "<cmd>CopilotChatCommit<cr>",        desc = "CopilotChat - Generate commit message for all changes" },
        { mode = 'n', key = '<space>ccM', action = "<cmd>CopilotChatCommitStaged<cr>",  desc = "CopilotChat - Generate commit message for staged changes" },
      }

      for _, mapping in ipairs(mappings) do
        vim.keymap.set(mapping.mode, mapping.key, mapping.action, { silent = true, desc = mapping.desc })
      end
    end,
  },
}
