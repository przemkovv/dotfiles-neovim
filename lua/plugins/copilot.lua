
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
  {
    "folke/sidekick.nvim",
    enabled = false,
    opts = {
      -- add any options here
      cli = {
        mux = {
          enabled = false,
        },
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      -- {
      --   "<space>aa",
      --   function() require("sidekick.cli").toggle() end,
      --   mode = { "n", "v" },
      --   desc = "Sidekick Toggle CLI",
      -- },
      {
        "<space>as",
        function()
          -- require("sidekick.cli").select()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        -- Or to select only installed tools:
        desc = "Sidekick Select CLI",
      },
      {
        "<space>as",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "v" },
        desc = "Sidekick Send Visual Selection",
      },
      {
        "<space>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "v" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<space>aa",
        function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
        desc = "Sidekick Copilot Toggle",
        mode = { "n", "v" },
      },
    },
    debug = false, -- enable debug logging
  }
}
