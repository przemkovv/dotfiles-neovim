local M = {}

local parse_cmake_preset = function(vars, text)
  -- str = "${sourceDir}/out/build/${presetName}"
  -- str = "$env{RTT_BUILD_ROOT}/out/build/${presetName}"
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
    vim.notify("Could not find CMakePresets.json")
    return nil
  end
  local file = io.open(presets_file, "r")
  if not file then
    vim.notify("Could not open file CMakePresets.json")
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

function M.select_cmake_configuration()
  local build_configurations = M.get_cmake_preset_build_configurations()
  local all_configurations = {}
  if build_configurations ~= nil then
    all_configurations = vim.fn.keys(build_configurations)
  end
  vim.ui.select(all_configurations, {
    prompt = "Select CMake configuration",
  }, function(choice)
    vim.print("Selected configuration: " .. choice)
    M.setup_make(choice)
  end)
end

function M.setup_make(configuration)
  local build_configurations = M.get_cmake_preset_build_configurations()
  local fallback = false
  if build_configurations == nil then
    vim.notify("Could not find CMakePresets.json")
    fallback = true
  end

  if build_configurations ~= nil and build_configurations[configuration] == nil then
    vim.notify("Could not find build configuration " .. configuration)
    fallback = true
  end
  if build_configurations ~= nil and build_configurations[configuration] ~= nil then
    vim.opt.makeprg = "cmake --build --preset " .. build_configurations[configuration].name
    vim.g.configureprg = "cmake --preset " .. build_configurations[configuration].configure_preset
    vim.g.build_dir = build_configurations[configuration].binary_dir
  end

  if fallback == true then
    vim.notify("Fallback")
    if vim.fn.has('windows') then
      vim.opt.makeprg = "cmake --build --preset windows-" .. configuration
      vim.g.configureprg = "cmake --preset windows-msvc-" .. configuration
      vim.g.build_dir = "out/build/windows-msvc-" .. configuration
    else
      vim.opt.makeprg = "cmake --build --preset linux-clang"
      vim.g.configureprg = "cmake --preset linux-clang"
    end
  end

  for _, client in ipairs(vim.lsp.get_clients({ name = "cmake" })) do
    client:notify('workspace/didChangeConfiguration',
      {
        settings = { initialization_options = { buildDirectory = vim.g.build_dir } } })
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("cmake_configuration", {}),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client ~= nil and client.name == "cmake" then
        client:notify("workspace/didChangeConfiguration", {
          settings = { initialization_options = { buildDirectory = vim.g.build_dir } } })
      end
    end,
  })
end

local switch_cmake_configuration_telescope = function(prompt_bufnr)
  local actions_state = require('telescope.actions.state')
  local selection = actions_state.get_selected_entry()
  local actions = require('telescope.actions')
  actions.close(prompt_bufnr)
  local was_cmake_enabled = vim.lsp.is_enabled('cmake')
  vim.lsp.enable('cmake', false)
  M.setup_make(selection[1])
  vim.lsp.enable('cmake', was_cmake_enabled)
  vim.notify("Configuration switched to " .. selection[1])
end

function M.pick_cmake_configuration()
  local sorters = require('telescope.sorters')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  pickers.new({}, {
    prompt_title = "CMake configuration",
    finder = finders.new_table {
      results = M.get_cmake_preset_build_configurations_names(),
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(_, map)
      map("n", "<cr>", switch_cmake_configuration_telescope)
      map("i", "<cr>", switch_cmake_configuration_telescope)
      return true
    end,
  }):find()
end

---@class pick_executable.Item
---@field target_name string
---@field executable string

---@class pick_executable.Opts
---@field on_selection fun(item: pick_executable.Item) | nil

---@param opts pick_executable.Opts|nil
function M.pick_executable(opts)
  local cwd = vim.g.build_dir .. "/.cmake/api/v1/reply"
  local pick = require('mini.pick')
  -- Centered on screen
  local win_config = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)
    return {
      anchor = 'NW',
      height = height,
      width = width,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
      border = 'rounded'
    }
  end
  pick.builtin.cli({
    command =
    { "fd", "target-.*\\.json",
      "-X", "jq", "-s",
      "[.[] | select(.type == \"EXECUTABLE\") | . as $root| { target_name: $root.name, executable: ($root.artifacts[].path |select(endswith($root.nameOnDisk))) }]|select(isempty(.[])==false) " },
    postprocess = function(data)
      local json_string = table.concat(data)
      local items = vim.json.decode(json_string)
      -- print(vim.inspect(items))
      return items
    end,
    spawn_opts = {
      cwd = cwd,
    }
  }, {
    window = { config = win_config },
    source = {
      name = "Executable selection",
      ---@param item pick_executable.Item
      choose = function(item)
        if opts ~= nil and opts.on_selection ~= nil then
          opts.on_selection(item)
        end
      end,
      show =
          function(buf_id, items_arr, _)
            local lines = vim.tbl_map(function(x)
              return x.target_name .. '         ->        ' .. x.executable
            end, items_arr)
            vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
          end
    }
  })
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
  require("overseer").run_template(
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

      require("overseer").run_template(
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
    -- vim.g.msvcpath = vim.fn.shellescape(vim.fn.expand("${VCToolsInstallDir}")) .. "include/.*"
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

return M
