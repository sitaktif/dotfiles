set et
set sw=4
set sts=4
set smarttab
set nosmartindent

set completeopt=menuone,longest,preview

"nnoremap <buffer> <f5> :!/usr/bin/python ./%<cr>
"Temporary
"nnoremap <buffer> <f5> :!/usr/bin/python ./ts.py<cr>

nnoremap <buffer> <f5> :!python ./%<cr>
nnoremap <buffer> <f6> :!nosetests %:h<cr>
" Run tests with output
nnoremap <buffer> <S-f6> :!nosetests %:h --nocapture<cr>


"syn match pythonError "^\s*def\s\+\w\+(.*)\s*$" display
"syn match pythonError "^\s*class\s\+\w\+(.*)\s*$" display
"syn match pythonError "^\s*for\s.*[^:]$" display
"syn match pythonError "^\s*except\s*$" display
"syn match pythonError "^\s*finally\s*$" display
"syn match pythonError "^\s*try\s*$" display
"syn match pythonError "^\s*else\s*$" display
"syn match pythonError "^\s*else\s*[^:].*" display
"syn match pythonError "^\s*if\s.*[^\:]$" display
"syn match pythonError "^\s*except\s.*[^\:]$" display
"syn match pythonError "[;]$" display
"syn keyword pythonError         do 
"hi link pythonError Error

" Make program and debug with :cn and :cp
"autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
"autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m 


if has('python')

" Add the virtualenv's site-packages to vim path
python << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

" Evaluate a pyhon bunch of code
python << EOL
import vim
def PyEval():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL
map <C-h> :py PyEval() 

endif
