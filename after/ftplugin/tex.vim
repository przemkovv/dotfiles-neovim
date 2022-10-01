" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
setlocal sw=4
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
setlocal iskeyword+=:

setlocal spell
setlocal spelllang=en,pl

setlocal wrap linebreak textwidth=0
" setlocal showbreak=…
let &showbreak='↳ '

let g:tex_indent_items=1
let g:tex_flavor='latex'
let g:tex_conceal="abdgm"

let g:vimtex_fold_enabled = 0
let g:vimtex_view_method = 'zathura'
let g:vimtex_latexmk_progname = 'nvr'
let g:vimtex_compiler_progname = 'nvr'

let g:vimtex_compiler_latexmk = {
      \ 'backend' : 'nvim',
      \ 'background' : 1,
      \ 'build_dir' : '',
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \}
let g:vimtex_quickfix_latexlog = {
      \ 'default' : 1,
      \ 'general' : 1,
      \ 'references' : 1,
      \ 'overfull' : 0,
      \ 'underfull' : 0,
      \ 'font' : 1,
      \ 'packages' : {
      \   'default' : 1,
      \   'natbib' : 1,
      \   'biblatex' : 1,
      \   'babel' : 1,
      \   'hyperref' : 1,
      \   'scrreprt' : 1,
      \   'fixltx2e' : 1,
      \   'titlesec' : 1,
      \ },
      \}

let g:vimtex_quickfix_latexlog = {
      \ 'overfull' : 0,
      \ 'underfull' : 0,
      \ 'packages' : {
      \   'default' : 0,
      \ },
      \}

call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex' : g:vimtex#re#deoplete,
      \})
