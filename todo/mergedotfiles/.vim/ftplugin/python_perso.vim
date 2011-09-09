""" PYTHON CONFIGURATION FILE """

let s:path = expand('<sfile>:p:h')

set expandtab "Replace tabs by spaces


map <F1> :Pydoc <C-R><C-W>
map <F5> :!python %<CR>
map <S-F5> :!python main.py<CR>

map <F12> :!/usr/lib/python2.5/Tools/scripts/ptags.py -R .<CR><CR>

" Note: tag file should be already added in "&tags" for each ft, in vimrc
map <S-F12> :!ctags -R -f ~/.vim/tags/python_tags /usr/lib/python2.5/<CR><CR>
set tags=tags,TAGS,./tags,./TAGS,~/.vimrc/tags/python.tags


if g:PLATFORM =~ 'mac'
  " Sets the paths for Vim AND Python. Useful to get pythoncomplete to work
  function! SetPythonEnv()
      if has('python')
          " F**KING Python 2.3 on MacVim
          python import vim, sys ; vim.command('set path+='+",".join(sys.path))
          set path+=/sw/lib/python26.zip,/sw/lib/python2.6,/sw/lib/python2.6/plat-darwin,/sw/lib/python2.6/plat-mac,/sw/lib/python2.6/plat-mac/lib-scriptpackages,/sw/lib/python2.6/lib-tk,/sw/lib/python2.6/lib-old,/sw/lib/python2.6/lib-dynload,/sw/lib/python2.6/site-packages
          python import vim, sys ; sys.path.extend(vim.eval('split(&path,",")'))
      else
          if g:PLATFORM == 'mac'
              set path+=/sw/lib/python26.zip,/sw/lib/python2.6,/sw/lib/python2.6/plat-darwin,/sw/lib/python2.6/plat-mac,/sw/lib/python2.6/plat-mac/lib-scriptpackages,/sw/lib/python2.6/lib-tk,/sw/lib/python2.6/lib-old,/sw/lib/python2.6/lib-dynload,/sw/lib/python2.6/site-packages
          endif
      endif
      set previewheight=16
  endfunction
  au FileType python call SetPythonEnv()
endif


"" Fix import files

" Basically, when from a.b import c.d, it looks for
" a/b/c/d, a/b/c, a/b, a and
" b/c/d, b/c, b and c/d, c and d (with a ".py" at the end...)
function! PYPERSO_GetIncludeExpr()
    let l:line = getline('.')
    let l:folder = substitute(l:line, '\%(from \(\S\+\)\s\+\)import\s\+
\(\S\)\(\)', '\1.\2', '')
    echomsg(l:folder)
    let l:folder_list_init = split(l:folder, '\.')
    while (l:folder_list_init != [])
        let l:folder_list = l:folder_list_init
        echomsg(string(l:folder_list))
        while (l:folder_list != [])
            let l:tempfile = expand('%:p:h').'/'.join(folder_list, '/').'.py'
            echoerr l:tempfile
            if (filereadable(l:tempfile))
                return l:tempfile
            endif
            let l:folder_list = l:folder_list[:-1]
        endwhile
        let l:folder_list_init = l:folder_list_init[1:]
    endwhile
    return 0
endfunc
