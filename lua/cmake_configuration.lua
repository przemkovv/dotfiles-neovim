local M = {}

local parse_cmake_preset = function(vars, text)
  -- str = "${sourceDir}/out/build/${presetName}"
  return text:gsub("%${(.-)}", function(key)
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
          inherit = preset.inherits
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
      build_presets[preset.name] = {
        name = preset.name,
        description = preset.description,
        configure_preset = preset.configurePreset,
        binary_dir = parse_cmake_preset({ sourceDir = ".", presetName = configure_preset.name }, binary_dir_template),
        install_dir = parse_cmake_preset({ sourceDir = ".", presetName = configure_preset.name }, install_dir_template)
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
  if fallback == false then
    vim.notify("Not Fallback")
    vim.opt.makeprg = "cmake --build --preset " .. build_configurations[configuration].name
    vim.g.configureprg = "cmake --preset " .. build_configurations[configuration].configure_preset
    vim.g.remedy_session_file = "./endorobot.rdbg"
    vim.g.build_dir = build_configurations[configuration].binary_dir
  else
    vim.notify("Could not find CMakePresets.json")
  end

  if fallback == true then
    vim.notify("Fallback")
    if vim.fn.has('windows') then
      vim.opt.makeprg = "cmake --build --preset windows-" .. configuration
      vim.g.configureprg = "cmake --preset windows-msvc-" .. configuration
      vim.g.remedy_session_file = "./endorobot.rdbg"
      vim.g.build_dir = "out/build/windows-msvc-" .. configuration
    else
      vim.opt.makeprg = "cmake --build --preset linux-clang"
      vim.g.configureprg = "cmake --preset linux-clang"
      vim.g.remedy_session_file = nil
    end
  end

  for _, client in ipairs(vim.lsp.get_clients({ name = "cmake" })) do
    -- client.config.init_options.buildDirectory = vim.g.build_dir
    vim.notify("Notifying cmake lsp")
    -- client.notify("workspace/didChangeConfiguration")
    client.notify("workspace/didChangeConfiguration", {
      settings = { initialization_options = { buildDirectory = vim.g.build_dir } } })
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("cmake_configuration", {}),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client ~= nil and client.name == "cmake" then
        -- client.config.init_options.buildDirectory = vim.g.build_dir
        client.notify("workspace/didChangeConfiguration", {
          settings = { initialization_options = { buildDirectory = vim.g.build_dir } } })
      end
    end,
  })
end

-- Create a custom picker
local pickers = require('telescope.pickers')
local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')

local switch_cmake_configuration_telescope = function(prompt_bufnr)
  local selection = actions_state.get_selected_entry()
  actions.close(prompt_bufnr)
  M.setup_make(selection[1])
  vim.notify("Configuration switched to " .. selection[1])
end

function M.pick_cmake_configuration()
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

return M
