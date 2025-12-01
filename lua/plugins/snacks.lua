return {
  {
    "folke/snacks.nvim",
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        ui_select = true,
        layout = {
          preset = "custom",
          cycle = true,
        },
        sources = {
          select = {
            -- layout = { preset = "custom_select" }
          }
        },
        layouts = {
          custom_select = {
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.4,
              border = "none",
              title = " {title} {live} {flags}",
              title_pos = "left",
              {
                box = "horizontal",
                { win = "list", border = "rounded" },
              },
              { win = "input", height = 1, border = "top" },
            },
          },
          custom = {
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.4,
              border = "none",
              title = " {title} {live} {flags}",
              title_pos = "left",
              {
                box = "horizontal",
                { win = "list",    border = "rounded" },
                { win = "preview", title = "{preview}", width = 0.6, border = "rounded" },
              },
              { win = "input", height = 1, border = "top" },
            }
          },
        },
      },
      image = {
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
          end
        end,
      },
    },
  },
}
