local vaults_root = '~/Documents/vaults/'
-- if vim.fn.has('win32') == 1 and vim.fn.hostname() == 'MA-605' then
--   vaults_root = 'c:/Users/pwalkowiak/Documents/vaults/'
-- end

return {
  -- lazy.nvim
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      image = {
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
          end
        end,
      },
    }
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    ft = "markdown",
    cmd = { "Obsidian" },
    keys = {
      { "<localleader>oo", '<cmd>Obsidian<cr>',                 desc = "Obsidian commands" },
      { "<localleader>oc", '<cmd>Obsidian toggle_checkbox<cr>', desc = "Obsidian checkbox" },
    },
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in the next major release
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.date("%Y-%m-%d_%H-%M", os.time())) .. "-" .. suffix
      end,
      workspaces = {
        {
          name = "personal",
          path = vaults_root .. "personal",
        },
        {
          name = "mdg",
          path = vaults_root .. "mdg",
        },
        {
          name = "rtt",
          path = vaults_root .. "rtt",
        },
      },
      daily_notes = {
        folder = "daily",
        workdays_only = false,
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      cache = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "ObsidianNoteEnter",
        callback = function(ev)
          vim.keymap.set("n", "<localleader>ch", "<cmd>Obsidian toggle_checkbox<cr>", {
            buffer = ev.buf,
            desc = "Toggle checkbox",
          })
        end,
      })
    end,
  }
}
