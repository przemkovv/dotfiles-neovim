
function! LspError() abort
  let errorCount = 0
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let errorCount = luaeval("vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })")
  endif
  return 'E: '.errorCount
endfunction

function! LspWarning() abort
  let warningCount = 0
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let warningCount = luaeval("vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })")
  endif
  return 'W: '.warningCount
endfunction

function! LspStatus() abort
  let sl = ''
  if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
  " if luaeval('vim.lsp.get_active_clients({bufno=vim.api.nvim_win_get_buf(0)})')
    let sl.='LSP: on'
  else
    let sl.='LSP: off'
  endif
  return sl
endfunction

function! myfunctions#airline#AirlineInit()
  call airline#parts#define_function('nvim-lsp-status', 'LspStatus')
  " call airline#parts#define_function('nvim-lsp-error', 'LspError')
  " call airline#parts#define_function('nvim-lsp-warning', 'LspWarning')
  call airline#parts#define_condition('nvim-lsp-warning',  "luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')")
  call airline#parts#define_condition('nvim-lsp-error',  "luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')")

  call airline#parts#define_raw('file2', "%#User1#%t %m")
  call airline#parts#define_raw('path2', "%{expand('%:h')}/")
  let g:airline_section_c = airline#section#create(['%<','path2', 'file2',  'readonly'])

  let g:airline_section_x = airline#section#create_right(['tagbar'])
  let g:airline_section_y = airline#section#create_right(['filetype'])
  " let g:airline_section_y = airline#section#create(['%{airline#util#wrap(airline#parts#filetype(),0)}'])
  " let g:airline_section_z = airline#section#create(['%3p%%',  ' %c:%l/%L [%{winnr()}]'])
  let g:airline_section_z = airline#section#create_right([ 'nvim-lsp-status', '%3p%% ',  ' %c:%l/%L'])
        " \ 'nvim-lsp-error',
  let g:airline_section_error = airline#section#create_right([
        \ 'ycm_error_count',
        \ 'syntastic-err',
        \ 'eclim',
        \ 'languageclient_error_count'])
        " \ 'nvim-lsp-warning',
  let g:airline_section_warning = airline#section#create_right([
        \ 'ycm_warning_count',
        \ 'syntastic-warn',
        \ 'languageclient_warning_count',
        \ 'whitespace'])
  " let w:airline_section_z = airline#section#create_right(['nvim-lsp'])
endfunction
