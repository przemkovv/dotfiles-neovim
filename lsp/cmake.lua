local get_build_dir = function()
  local build_dir = "build/"
  if vim.g.build_dir ~= nil then
    build_dir = vim.g.build_dir
  end
  return build_dir
end

return {
  cmd = {
    "cmake-language-server",
  },
  filetypes = { "cmake" },
  single_file_support = true,
  init_options = {
    buildDirectory = get_build_dir(),
    root_pattern = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake', 'out' }
  }
}
