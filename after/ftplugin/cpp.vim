
" let b:fswitchdst = 'cpp,h,hpp' 
let b:fswitchlocs = '.'
" setlocal foldmethod=marker foldmarker={,} foldlevel=99
setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
" setlocal colorcolumn=81

setlocal mps+=<:>

augroup ft_cpp_include
  autocmd!
  autocmd BufRead,BufNewFile /usr/include/c++/* setlocal syntax=cpp
augroup END

