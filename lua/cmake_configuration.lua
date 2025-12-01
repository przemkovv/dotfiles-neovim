local M = {}

local local_settings_dir = ".local_settings"
local configuration_file = local_settings_dir .. "/cmake.json"


---@class pick_executable.Item
---@field target_name string
---@field executable string
---
---@class pick_executable.Opts
---@field on_selection fun(item: pick_executable.Item) | nil


---@class pick_cmake_configuration.Configuration
---@field name string
---@field build_dir string


---@class pick_cmake_configuration.Opts
---@field force_pick boolean | nil

local parse_cmake_preset = function(vars, text)
  return text:gsub("%$env{(.-)}", function(key)
    return vim.env[key] or key
  end):gsub("%${(.-)}", function(key)
    return vars[key] or key
  end)
end

local file_exists = function(name)
  local file = io.open(name, "r")
  if file ~= nil then
    io.close(file)
    return true
  else
    return false
  end
end

local get_table_length = function(t)
  if t == nil then
    return 0
  end
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

function M.get_cmake_preset_build_configurations()
  local presets_file = "CMakePresets.json"
  if not file_exists(presets_file) then
    vim.print("Could not find CMakePresets.json")
    return nil
  end
  local file = io.open(presets_file, "r")
  if not file then
    vim.print("Could not open file CMakePresets.json")
    return nil
  end
  local presets = vim.json.decode(file:read("*a"))
  file:close()

  local binary_dir_template = nil
  local install_dir_template = nil

  local configurePresets = {}
  local configurePresetsToProcess = {}
  for _, preset in ipairs(presets.configurePresets) do
    if preset.name == "conf-common" then
      binary_dir_template = preset.binaryDir
      install_dir_template = preset.installDir
    end

    if preset.binaryDir ~= nil then
      configurePresets[preset.name] = preset
    else
      configurePresetsToProcess[preset.name] = preset
    end
  end
  while configurePresetsToProcess ~= nil and get_table_length(configurePresetsToProcess) > 0 do
    for name, preset in pairs(configurePresetsToProcess) do
      local all_inherited_checked = true
      if preset.inherits ~= nil then
        if type(preset.inherits) == "string" then
          local inherit = preset.inherits
          if configurePresets[inherit] ~= nil then
            if configurePresets[inherit].binaryDir ~= nil then
              preset.binaryDir = configurePresets[inherit].binaryDir
            end
          else
            all_inherited_checked = false
          end
        else
          for _, inherit in ipairs(preset.inherits) do
            if configurePresets[inherit] ~= nil then
              if configurePresets[inherit].binaryDir ~= nil then
                preset.binaryDir = configurePresets[inherit].binaryDir
              end
            else
              all_inherited_checked = false
            end
          end
        end
      end

      if all_inherited_checked == true then
        configurePresets[name] = preset
        configurePresetsToProcess[name] = nil
      end
    end
  end



  local all_build_presets = presets.buildPresets or {}
  local build_presets = {}
  for _, preset in ipairs(all_build_presets) do
    if preset.hidden == nil or preset.hidden == false then
      local configure_preset = configurePresets[preset.configurePreset]
      if configure_preset.binaryDir ~= nil then
        binary_dir_template = configurePresets[preset.configurePreset].binaryDir
      end
      local replacement_opts = {
        sourceDir = ".",
        presetName = configure_preset.name,
      }
      build_presets[preset.name] = {
        name = preset.name,
        description = preset.description,
        configure_preset = preset.configurePreset,
        binary_dir = parse_cmake_preset(replacement_opts, binary_dir_template),
        install_dir = parse_cmake_preset(replacement_opts, install_dir_template)
      }
    end
  end
  return build_presets
end

---@return string[]
function M.get_cmake_preset_build_configurations_names()
  local build_presets = M.get_cmake_preset_build_configurations()
  if build_presets == nil then
    return {}
  end
  local names = {}
  for name, _ in pairs(build_presets) do
    table.insert(names, name)
  end
  return names
end

---@param build_dir string
function M.setup_cmake_lsp(build_dir)
  vim.lsp.config('cmake', {
    init_options = {
      buildDirectory = build_dir,
    }
  })
  if not vim.lsp.is_enabled('cmake') then
    vim.lsp.enable('cmake')
  else
    for _, client in ipairs(vim.lsp.get_clients({ name = "cmake" })) do
      client:notify('workspace/didChangeConfiguration',
        {
          settings = { initialization_options = { buildDirectory = build_dir } } })
    end
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("cmake_configuration", {}),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client ~= nil and client.name == "cmake" then
        client:notify("workspace/didChangeConfiguration", {
          settings = { initialization_options = { buildDirectory = build_dir } } })
      end
    end,
  })
end

---@param configuration string
---@return string "missing_presets_file"|"missing_configuration"|"success"
function M.setup_cmake(configuration)
  local build_configurations = M.get_cmake_preset_build_configurations()
  if build_configurations == nil then
    vim.print("Could not find CMakePresets.json")
    return "missing_presets_file"
  end

  if build_configurations ~= nil and build_configurations[configuration] == nil then
    vim.print("Could not find build configuration " .. configuration)
    return "missing_configuration"
  end

  vim.opt.makeprg = "cmake --build --preset " .. build_configurations[configuration].name
  vim.g.configureprg = "cmake --preset " .. build_configurations[configuration].configure_preset
  vim.g.build_dir = build_configurations[configuration].binary_dir
  return "success"
end

---@param choice string|nil
function M.switch_cmake_configuration(choice)
  if choice == nil then
    return
  end
  local result = M.setup_cmake(choice)
  if result == "success" then
    M.setup_cmake_lsp(vim.g.build_dir)
    vim.print("Configuration switched to " .. choice)
  end
  if result == "missing_configuration" then
    M.pick_cmake_configuration({ force_pick = true })
  end
end

--- Find all executable cmake targets in the given directory
---@param cwd string
---@return pick_executable.Item[]
local find_all_executable_cmake_targets = function(cwd)
  local Job = require('plenary.job')

  local jq_transform = Job:new({
    command = "fd",
    args =
    { "target-.*\\.json",
      "-X", "jq", "-s",
      "[.[] | select(.type == \"EXECUTABLE\") | . as $root| { target_name: $root.name, executable: ($root.artifacts[].path |select(endswith($root.nameOnDisk))) }]|select(isempty(.[])==false) " },
    cwd = cwd,
    enable_recording = true,
  })
  local j = Job:new({
    command = "jq",
    enable_recording = true,
    args = { "-s", ". | flatten" },
    cwd = cwd,
    writer = jq_transform
  })
  j:sync()

  local res = j:result()
  if (res == nil or #res == 0) then
    vim.print("No executables found in build directory")
    return {}
  end

  local items = vim.json.decode(table.concat(res))
  return items
end


function M.compile_current_file()
  -- Get the current file path
  local current_file = vim.api.nvim_buf_get_name(0)

  -- Load compile_commands.json file
  local compile_commands_path = vim.g.build_dir .. "/compile_commands.json"
  local compile_commands_file = io.open(compile_commands_path, "r")
  if not compile_commands_file then
    print("Could not open compile_commands.json")
    return
  end

  local compile_commands_content = compile_commands_file:read("*a")
  compile_commands_file:close()

  -- Parse the JSON content
  local compile_commands = vim.fn.json_decode(compile_commands_content)

  -- Find the current file in the list
  local compile_command = nil
  for _, command in ipairs(compile_commands) do
    if command.file == current_file then
      compile_command = command.command
      break
    end
  end

  if not compile_command then
    print("Could not find compile command for the current file")
    return
  end

  -- Run the command
  require("overseer").run_task(
    {
      name = "Command runner",
      params = {
        cmd = compile_command,
        cwd = vim.g.build_dir,
        desc = "Compile current file"
      }
    })
end

function M.setup()
  vim.api.nvim_create_user_command("CMake",
    function(params)
      local prg = nil
      if params.fargs[1] == "build" then
        prg = vim.o.makeprg
      elseif params.fargs[1] == "configure" then
        prg = vim.g.configureprg
      elseif params.fargs[1] == "build_and_run" then
        prg = vim.o.makeprg
      else
        return
      end

      local args = vim.fn.expandcmd(string.sub(params.args, string.len(params.fargs[1]) + 1))
      -- Insert args at the '$*' in the makeprg
      local cmd, num_subs = prg:gsub("%$%*", args)
      if num_subs == 0 then
        cmd = cmd .. " " .. args
      end
      vim.notify("Starting " .. cmd)

      require("overseer").run_task(
        {
          name = "Command runner",
          params = {
            cmd = cmd,
            desc = "CMake runner"
          }
        })
    end,
    {
      desc = "Run your makeprg as an Overseer task",
      nargs = "*",
      bang = true,
      complete = function()
        return { "build", "configure", "build_and_run" }
      end,
    })


  if vim.fn.has('win32') then
    local msvcpath = vim.fn.getenv("VCToolsInstallDir")
    if msvcpath ~= vim.NIL then
      msvcpath = msvcpath:gsub("\\", "/"):gsub(" ", "\\ ")
      local msvcpath_expr = msvcpath .. "include/*"

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = msvcpath_expr,
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          vim.api.nvim_set_option_value("filetype", "cpp", { buf = buf })
        end
      })
    end
  end
end

---@param opts pick_executable.Opts|nil
function M.pick_executable(opts)
  local cwd = vim.g.build_dir .. "/.cmake/api/v1/reply"
  if cwd == nil then
    vim.print("Build directory is not set")
    return
  end
  local items = find_all_executable_cmake_targets(cwd)
  ---@diagnostic disable-next-line: deprecated
  local max_length = math.max(40, unpack(vim.tbl_map(function(item) return #item.target_name end, items))) + 2
  vim.ui.select(
    find_all_executable_cmake_targets(cwd),
    {
      prompt = "Select executable",
      format_item = function(item)
        return item.target_name .. (" "):rep(max_length - #item.target_name) .. item.executable
      end,
      snacks = {
        layout = "custom_select",
      },
    },
    function(item)
      if item == nil or opts == nil or opts.on_selection == nil then
        return
      end
      opts.on_selection(item)
    end)
end

function M.save_configuration(configuration)
  if vim.fn.isdirectory(local_settings_dir) == 0 then
    vim.fn.mkdir(local_settings_dir)
  end
  local file = io.open(configuration_file, "w")
  if file then
    local content = vim.json.encode({ configuration = configuration })
    file:write(content)
    file:close()
  end
end

function M.load_configuration()
  if vim.fn.filereadable(configuration_file) == 1 then
    local file = io.open(configuration_file, "r")
    if file then
      local content = file:read("*a")
      file:close()
      local config = vim.json.decode(content)
      if config ~= nil and config.configuration ~= nil then
        return config.configuration
      end
    end
  end
  return nil
end

---@param opts pick_cmake_configuration.Opts|nil
function M.pick_cmake_configuration(opts)
  local check_local_settings = opts ~= nil and opts.force_pick ~= true
  local saved_configuration = nil
  if check_local_settings then
    saved_configuration = M.load_configuration()
  end

  if saved_configuration == nil then
    vim.print("Please select a CMake configuration")
    vim.ui.select(
      M.get_cmake_preset_build_configurations_names(),
      {
        prompt = "Select CMake configuration",
        snacks = {
          layout = "custom_select",
        },
      },
      function(choice)
        M.switch_cmake_configuration(choice)
        M.save_configuration(choice)
      end)
  else
    vim.print("Using saved CMake configuration: " .. saved_configuration)
    M.switch_cmake_configuration(saved_configuration)
  end
end

return M
