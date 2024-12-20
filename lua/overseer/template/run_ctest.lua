return {
  name = "Run CTest",
  params = {
    test_name = {
      type = "string",
      default = nil,
      optional = true,
      default_from_task = true,
    },
    working_dir = {
      type = "string"
    },
    randomize = {
      type = "boolean",
      default = false,
      name = "randomize",
      optional = true,
      default_from_task = true,

    },
    repeat_n = {
      type = "integer",
      default = 1,
      name = "repeat",
      optional = true,
      default_from_task = true,
    },
    parallelize = {
      type = "boolean",
      name = "parallelize",
      default = true,
      optional = true,
      default_from_task = true,
    },
  },

  builder = function(params)
    local verbosity = ''
    local randomize = ''
    local test_option = ''
    local test_name = ''
    local repeat_n = tostring(params.repeat_n)
    local core_count = 1

    if params.randomize == true then
      randomize = '--schedule-random'
    end


    if params.test_name == nil then
      test_option = ""
      test_name = ""
      verbosity = '--progress'
    else
      test_option = '-R'
      test_name = params.test_name
      verbosity = '--verbose'
    end

    if params.parallelize == true then
      core_count = 16 -- vim.fn.system('nproc')
    end

    return {
      name = 'run ctest',
      cmd = { 'ctest' },
      args = { test_option, test_name, '--output-on-failure', verbosity, randomize, '--repeat-until-fail',
        repeat_n, '--parallel', core_count },
      cwd = params.working_dir,
      tags = { require("overseer").TAG.TEST },
      components = {
        { "on_output_quickfix",           open_on_exit = "failure" },
        { "on_output_summarize", max_lines = 10 },
        { "on_exit_set_status" },
        { "on_complete_notify" },
        { "unique",              replace = true },
        { "display_duration" },
      },
    }
  end
}
