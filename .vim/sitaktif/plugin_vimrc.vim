" This file contains .vimrc settings that are plugin-dependant
" I splitted my vimrc to share the "non-dependant" part easily

" ---| PLUGINS SETTINGS |--- {{{

" EasyMotion
" Use autocmd because we want it to be set last.
autocmd VimEnter * hi EasyMotionTarget ctermbg=none ctermfg=red
autocmd VimEnter * hi EasyMotionShade  ctermbg=none ctermfg=blue
"hi link EasyMotionTarget Error
"hi link EasyMotionShade  LineNr



" UltiSnips
let g:UltiSnipsSnippetDir = 'UltiSnips'
let g:UltiSnipsListSnippets = '<c-x><tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'


" Space plugin
nmap <unique> <F1> <Plug>SmartspaceNext
nmap <unique> <F2> <Plug>SmartspacePrev
"noremap <unique> <S-Space> <Plug>SmartspacePrevnongui
let g:space_no_second_prev_mapping = 1

" CSApprox
let g:CSApprox_verbose_level = 0

" Taglist plugin
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Enable_Fold_Column = 0
"let Tlist_Compact_Format = 1
let Tlist_Display_Prototype = 1
let Tlist_File_Fold_Auto_Close = 1 " Only display current file
let Tlist_Inc_Winwidth = 1
let Tlist_WinWidth = 48
" Taglist OCaml language
let g:tlist_ocaml_settings = 'ocaml;m:module;t:type;d:definition'
let g:tlist_omlet_settings = 'ocaml;m:module;t:type;d:definition'

"" Utl: a file opener
"map <F9> :Utl<cr>
"" Open link in split window
"map <S-F9> :Utl openLink underCursor split<cr>
"" Open link in new tab
"map <C-W><F9> :Utl openLink underCursor tabe
"" Custom open
"map <C-F9> :Utl ol

"Panel with list of functions, vars...
map <F10> :NERDTreeToggle<cr>
map <F11> :TagbarToggle<cr>
let g:tagbar_autoclose = 1

"" Showmarks plugin
"highlight SignColumn ctermbg=0
"highlight ShowMarksHLl ctermfg=166 ctermbg=0 guifg=#d75f00
"highlight ShowMarksHLu ctermfg=160 ctermbg=0 guifg=#d70000
"highlight ShowMarksHLo ctermfg=184 ctermbg=0 guifg=#d7d700
"highlight ShowMarksHLm ctermfg=203 ctermbg=0 guifg=#ff5f5f
"let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.'`^\""
"let g:showmarks_textlower="\t"
"let g:showmarks_textupper="\t"
"let g:showmarks_textother="\t"

" Obviousmode plugin
let g:obviousModeInsertHi = 'term=reverse,bold ctermbg=88'
let g:obviousModeCmdwinHi = 'term=reverse,bold ctermbg=130'

"" Imaps plugin (e.g. latex-suite)
"imap <C-J> <Plug>IMAP_JumpForward
"nmap <C-J> <Plug>IMAP_JumpForward
"vmap <C-J> <Plug>IMAP_JumpForward

"" SuperTab
" Deactivate supertab
let g:complType = 1
let g:SuperTabDefaultCompletionType = "context"

"" TaskList plugin
map <leader>td <Plug>TaskList

"" Gundo plugin - undo tree :)
map <leader>g :GundoToggle<CR>

"" Ack
nmap <leader>a <Esc>:Ack!

"}}}

" ---| FILETYPE PLUGINS |--- {{{

"" Python
" Pyflakes
if !has('python')
    let b:did_pyflakes_plugin = 1
endif
let g:pyflakes_use_quickfix = 0

" Sytastic Settings
" let g:syntastic_python_checkers = ["flake8"]
let g:syntastic_python_flake8_args = "--max-line-length=160 --ignore=E201,E202,C0103"
let g:syntastic_quiet_messages = { "type": "style" }

" Green test with python
map <leader>tg :set makeprg=python\ manage.py\ test\|:call MakeGreen()<CR>

" PyTest - Execute the tests
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
" PyTest - Cycle through test errors
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest error<CR>

" PEP8
let g:pep8_map='<leader>8'

" Rope
map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>


"" C
"autocmd FileType c,cpp source ~/.vim/syntax/opengl.vim
"autocmd FileType c,cpp source ~/.vim/syntax/cppQT.vim
"autocmd FileType c source ~/.vim/syntax/gtk/gtk.vim
"autocmd FileType c source ~/.vim/syntax/gtk/gdk.vim
"autocmd FileType c source ~/.vim/syntax/gtk/glib.vim


"" RUBY
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1


"" XML/HTML (xml.vim)
let html_use_css = 1
let xml_no_html = 1
let xml_use_xhtml = 1


"" JAVA
"Commenter (jcommenter.vim)
autocmd FileType java let b:jcommenter_class_author='Romain Chossart (romainchossart@gmail.com)'
autocmd FileType java let b:jcommenter_file_author='Romain Chossart (romainchossart@gmail.com)'
autocmd FileType java map <leader>jc :call JCommentWriter()<CR> 

"Completion
autocmd Filetype java setlocal omnifunc=javacomplete#Complete 
autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
autocmd Filetype java inoremap <buffer> <C-X><C-U> <C-X><C-U><C-P>
autocmd Filetype java inoremap <buffer> <C-S-Space> <C-X><C-U><C-P> 

" }}}
