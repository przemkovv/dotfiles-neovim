


setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=79
setlocal smarttab
setlocal expandtab
setlocal colorcolumn=72,80
setlocal nosmartindent
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

setlocal define=^\s*\\(def\\\\|class\\)

" Jesus tapdancing Christ, built-in Python syntax, you couldn't let me
" override this in a normal way, could you?
if exists("python_space_error_highlight") | unlet python_space_error_highlight | endif
" setlocal equalprg=autopep8\ --max-line-length\ 72\ -
" setlocal formatprg=autopep8\ -
setlocal equalprg=autopep8\ -
" setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
" setlocal equalexpr

" Jedi {{{
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = "1"

let g:jedi#documentation_command = ''
" }}}

" pymode {{{
let g:pymode_breakpoint = 0
" let g:pymode_lint_checkers = ['pylint']
" let g:pymode_lint_checkers = [ 'pyflakes', 'pep8', 'mccabe']
let g:pymode_lint_checkers = ['pylint', 'pyflakes', 'pep8', 'mccabe']
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
" }}}
"
"
