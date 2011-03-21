set et
set sw=4
set sts=4
set smarttab
set nosmartindent

setlocal syntax=python

"nnoremap <buffer> <f5> :!/usr/bin/python ./%<cr>
"Temporary
nnoremap <buffer> <f5> :!/usr/bin/python ./ts.py<cr>

nnoremap <buffer> <S-f5> :!/usr/bin/python ./%<cr>


nmap <buffer> <leader>pau :%s/<c-r><c-w>/_&/gc<cr>



" Create getter and setter
"TODO FFS !!!

syn match pythonError "^\s*def\s\+\w\+(.*)\s*$" display
syn match pythonError "^\s*class\s\+\w\+(.*)\s*$" display
syn match pythonError "^\s*for\s.*[^:]$" display
syn match pythonError "^\s*except\s*$" display
syn match pythonError "^\s*finally\s*$" display
syn match pythonError "^\s*try\s*$" display
syn match pythonError "^\s*else\s*$" display
syn match pythonError "^\s*else\s*[^:].*" display
syn match pythonError "^\s*if\s.*[^\:]$" display
syn match pythonError "^\s*except\s.*[^\:]$" display
syn match pythonError "[;]$" display
syn keyword pythonError         do 

" Make program and debug with :cn and :cp
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m 


" Evaluate a pyhon bunch of code
python << EOL
import vim
def PyEval():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL
map <C-h> :py PyEval() 
