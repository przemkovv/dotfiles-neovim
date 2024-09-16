return
{
  name = "Command runner",
  builder = function(params)
    return {
      cmd = params.cmd,
      cwd = params.cwd,
      name = params.name,
      desc = params.desc,
      -- strategy = {
      --   "jobstart",
      --   preserve_output = true,
      --   use_terminal = false,
      -- },
      strategy = {
        "toggleterm",
        use_shell = false,
        direction = "vertical",
        close_on_exit = false,
        open_on_start = false,
      },
      components = {
        {
          "on_output_quickfix",
          open = false,
          open_height = 8,
          tail = false,
          open_on_exit = "always"
        },
        { "on_complete_notify" },
        "default",
      },
    }
  end,
  params = {
    cmd = {
      type = "string"
    },
    cwd = {
      type = "string",
      optional = true
    },
    name = {
      type = "string",
      optional = true,
      default_from_task = true,
    },
    desc = {
      type = "string",
      optional = true,
      default_from_task = true,
    }
  }
}
