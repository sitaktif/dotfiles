setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=100
setlocal smarttab
setlocal expandtab

set completeopt=menuone,longest,preview

nnoremap <buffer> <f5> :!python %<cr>
nnoremap <buffer> <f6> :!nosetests %:h<cr>
" Run tests with output
nnoremap <buffer> <S-f6> :!nosetests %:h --nocapture<cr>

" Make program and debug with :cn and :cp
"autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
"autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m 

