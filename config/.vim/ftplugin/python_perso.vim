setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=100
setlocal smarttab
setlocal expandtab

nnoremap <buffer> <F9> :!python %<cr>
nnoremap <buffer> <F10> :!pytest %:h --no-cov<cr>
nnoremap <buffer> <S-F10> :!pytest %:h<cr>
nnoremap <buffer> <F22> :!pytest %:h<cr>
nnoremap <buffer> [21;2~ :!pytest %:h<cr>

" Make program and debug with :cn and :cp
"autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
"autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m 

