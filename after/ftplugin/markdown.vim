
let g:tagbar_type_markdown = {
            \ 'ctagstype' : 'markdown',
            \ 'kinds' : [
            \ 'h:headings'
            \ ],
            \ 'sort' : 0,
            \ }

setlocal foldlevel=999

" Use <localleader>1/2/3 to add headings.
nnoremap <buffer> <localleader>1 yypVr=:redraw<cr>
nnoremap <buffer> <localleader>2 yypVr-:redraw<cr>
nnoremap <buffer> <localleader>3 mzI#<space><ESC>`zll
nnoremap <buffer> <localleader>4 mzI#<space><ESC>`z

" setlocal textwidth=79
setlocal textwidth=0
setlocal wrapmargin=79
setlocal isfname+=32,&,(,)
setlocal complete+=kspell
