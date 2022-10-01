
" setlocal foldmethod=marker foldmarker={,} foldlevel=99
" setlocal equalprg=clang-format\ -assume-filename=%
" setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2

function! FormatFile()
  let l:lines="all"
  pyf /usr/share/clang/clang-format.py
endfunction
function! FormatSelection()
  pyf /usr/share/clang/clang-format.py
endfunction

" nnoremap <buffer> <Leader>= :call FormatFile()<CR>
" vnoremap <buffer> <Leader>= :call FormatSelection()<CR>


