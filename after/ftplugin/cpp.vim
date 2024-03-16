
setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
setlocal mps+=<:>

augroup ft_cpp_include
  autocmd!
  autocmd BufRead,BufNewFile /usr/include/c++/* setlocal syntax=cpp
augroup END

