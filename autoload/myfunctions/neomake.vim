
function! myfunctions#neomake#MyOnNeomakeJobFinished() abort
  let context = g:neomake_hook_context
  echom printf('The job for maker %s exited non-zero: %s',
        \ context.jobinfo.maker.name, context.jobinfo.exit_code)
endfunction

