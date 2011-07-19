" Use space instead of tabs
set expandtab

" This indentation is better than smartindent
set cindent

" C Indentation options
set cinoptions=:0,l1,t0,g0

set sw=4
set sts=4

" function! FoldBrace()
"   if getline(v:lnum+1)[0] == '{'
"     return '>1'
"   endif
"   if getline(v:lnum)[0] == '}'
"     return '<1'
"   endif
"   return foldlevel(v:lnum-1)
" endfunction
" set foldexpr=FoldBrace()
" set foldmethod=expr

