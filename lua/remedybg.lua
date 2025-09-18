local M = {}

M.rdbg_ctl = "remedy_control.exe"
M.server_name = "rdbg"
M.launch_file = ".rdbg/launch.rdbg.json"

local function on_read(_, data)
  if data then
    print(data)
  end
end

---@param command string
---@param args string|string[]|nil
local function send_command(command, args)
  ---@type string[]
  local cmd_args = { "--server-name", M.server_name, "--cmd", command }
  if (args ~= nil) then
    if type(args) == "string" then
      table.insert(cmd_args, args)
    else
      vim.list_extend(cmd_args, args)
    end
  end
  -- print(vim.inspect(cmd_args))

  local stdout = vim.uv.new_pipe(false) -- create file descriptor for stdout
  local stderr = vim.uv.new_pipe(false) -- create file descriptor for stdout
  if stdout == nil or stderr == nil then
    return
  end
  handle = vim.uv.spawn(M.rdbg_ctl, {
      args = cmd_args,
      stdio = { nil, stdout, stderr }
    },
    function()
      handle:close()
    end
  )
  vim.uv.read_start(stdout, on_read)
  vim.uv.read_start(stderr, on_read)
  vim.uv.close(handle)
end

function M.run_debugger()
  vim.notify("Starting debugger")
  if vim.g.remedy_session_file ~= nil then
    send_command("start-debugger", { "--session-file", vim.g.remedy_session_file })
  else
    send_command("start-debugger")
  end
end

function M.start_debug()
  vim.notify("Starting debugging");
  send_command("start-debugging")
end

function M.stop_debug()
  vim.notify("Stopping debugging");
  send_command("stop-debugging")
end

function M.setup()
  if #vim.fn.sign_getdefined("RemedyBreakpoint") == 0 then
    vim.fn.sign_define("RemedyBreakpoint", { text = "B", texthl = "Error" })
  end
end

function M.toggle_breakpoint()
  M.setup()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local path = vim.fn.expand('%:p')
  local bufname = vim.fn.bufname()
  local placed = vim.fn.sign_getplaced(bufname, { group = 'RemedyBreakpoint', lnum = linenr })
  if #placed[1].signs == 0 then
    vim.notify("Adding breakpoint");
    send_command("add-breakpoint-at-filename-line", { "--file", path, "--line-num", linenr })
    vim.fn.sign_place(0, "RemedyBreakpoint", "RemedyBreakpoint", path, { lnum = linenr, priority = 10 })
  else
    vim.notify("Removing breakpoint");
    send_command("delete-breakpoint-at-filename-line", { "--file", path, "--line-num", linenr })
    vim.fn.sign_unplace("RemedyBreakpoint", { buffer = bufname, lnum = linenr })
  end
end

---@class LaunchTasksConfiguration
---@field type string
---@field project string
---@field projectTarget string
---@field name string
---@field args string[]|nil
---@field program string|nil
---@field cwd string|nil

---@class LaunchTasks
---@field version string
---@field defaults table[]
---@field configurations LaunchTasksConfiguration[]

---@param launch_file string
---@return LaunchTasks|nil
function M.load_launch_tasks(launch_file)
  local file = io.open(launch_file, "r")
  if not file then
    vim.notify("Could not open file " .. launch_file)
    return nil
  end

  ---@type LaunchTasks
  local tasks = vim.json.decode(file:read("*a"))
  file:close()
  return tasks
end

--@param tasks LaunchTasks
--@param launch_file string
function M.save_launch_tasks(tasks, launch_file)
  local json = vim.json.encode(tasks, { indent = "    ", sort_keys = true })
  local file = io.open(launch_file, 'w')
  if file == nil then
    vim.notify("Could not open file to write " .. launch_file)
    return
  end
  file:write(json)
  file:close()
end

---@param configurations LaunchTasksConfiguration[]
---@param target_name string
---@return LaunchTasksConfiguration|nil
function M.find_launch_configuration(configurations, target_name)
  for _, configuration in ipairs(configurations) do
    if configuration.projectTarget == target_name then
      return configuration
    end
  end
end

---@param configurations LaunchTasksConfiguration[]
---@param target_name string
---@param executable string
function M.add_launch_configuration(configurations, target_name, executable)
  ---@type LaunchTasksConfiguration
  local configuration = {
    type = "exe",
    project = "CMakeLists.txt",
    name = target_name .. " (" .. executable .. ")",
    projectTarget = target_name,
    program = executable,
    args = {},
    cwd = nil,
  }
  table.insert(configurations, configuration)
  return configuration
end

---@class start_debugging.Item
---@field target_name string
---@field executable string

---@param build_dir string
---@param item start_debugging.Item
function M.start_debugging(build_dir, item)
  vim.notify("Starting debugging");
  local tasks = M.load_launch_tasks(M.launch_file)
  if tasks == nil then
    return
  end
  local configuration = M.find_launch_configuration(tasks.configurations, item.target_name)
  if configuration == nil then
    configuration = M.add_launch_configuration(tasks.configurations, item.target_name, item.executable)
    M.save_launch_tasks(tasks, M.launch_file)
  end

  local args = {}
  local executable = vim.fs.joinpath(build_dir, configuration.program)
  vim.list_extend(args, { "--exec", executable })
  if configuration.args ~= nil and #configuration.args ~= 0 then
    vim.list_extend(args, { "--exec-args", table.concat(configuration.args, " ") })
  end
  if configuration.cwd == nil or configuration.cwd == "" then
    configuration.cwd = vim.fs.dirname(executable)
  end
  vim.list_extend(args, { "--exec-cwd", configuration.cwd })
  if configuration.name ~= nil and #configuration.name ~= 0 then
    vim.list_extend(args, { "--name", configuration.name })
  end
  M.save_launch_tasks(tasks, M.launch_file)

  send_command("debug-executable", args)
end

return M
