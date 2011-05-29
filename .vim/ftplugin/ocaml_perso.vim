" OCamL

autocmd FileType ocaml,caml,omlet setlocal suffixesadd=.ml,.mli
autocmd FileType ocaml,caml,omlet setlocal includeexpr=substitute(v:fname,'.','\\l&','g')
autocmd FileType ocaml,caml,omlet let g:tlist_def_ocaml_settings = 'ocaml;m:module;t:type;d:definition'
autocmd FileType ocaml,caml,omlet nmap <F5> :!ocaml <cfile><CR>

"autocmd FileType ocaml,caml,omlet let Tlist_Ctags_Cmd = '/usr/local/bin/otags'

