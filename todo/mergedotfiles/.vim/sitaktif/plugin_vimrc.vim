" This file contains .vimrc settings that are plugin-dependant
" I splitted my vimrc to share the "non-dependant" part easily

" ---| PLUGINS SETTINGS |--- {{{

" Vim Outliner
hi OL5 guifg=DarkCyan	ctermfg=DarkCyan
hi OL6 guifg=DarkGray	ctermfg=DarkGray

syntax match SitaComment /\*\w\+\*/
highlight SitaComment gui=bold term=bold cterm=bold

syntax keyword SitaNote NOTE
highlight SitaNote gui=underline term=underline ctermfg=DarkGray

syntax keyword SitaTodo TODO
highlight SitaTodo guibg=DarkBlue term=underline ctermbg=DarkBlue

syntax keyword SitaXxx XXX
highlight SitaXxx guibg=Red term=underline ctermbg=Red


" TwitVim
let twitvim_login_b64 = "c2l0YWt0aWY6NTY2MjU2NjI="
let twitvim_enable_python = 1

" Taglist plugin
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 0
let Tlist_Inc_Winwidth = 1
" Taglist OCaml language
let g:tlist_ocaml_settings = 'ocaml;m:module;t:type;d:definition'
let g:tlist_omlet_settings = 'ocaml;m:module;t:type;d:definition'

map \tp :TlistShowPrototype<cr>

"I WAS UNTIL HERE IN GITHUB !

"" Utl : a file opener
"map <F9> :Utl<cr>
"" Open link in split window
"map <S-F9> :Utl openLink underCursor split<cr>
"" Open link in new tab
"map <C-W><F9> :Utl openLink underCursor tabe
"" Custom open
"map <C-F9> :Utl ol
"
"Panel with list of functions, vars...
map <F10> :NERDTreeToggle<cr>
map <F11> :TlistToggle<cr>

" Showmarks plugin personnal tweaks
highlight SignColumn ctermbg=0
highlight ShowMarksHLl ctermfg=166 ctermbg=0 guifg=#d75f00
highlight ShowMarksHLu ctermfg=160 ctermbg=0 guifg=#d70000
highlight ShowMarksHLo ctermfg=184 ctermbg=0 guifg=#d7d700
highlight ShowMarksHLm ctermfg=203 ctermbg=0 guifg=#ff5f5f
let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.'`^\""
let g:showmarks_textlower="\t"
let g:showmarks_textupper="\t"
let g:showmarks_textother="\t"

" cecutils.vim (win saver/restorer) (cf. ~/.vim/plugin/cecutil.vim)
"map <unique> <Leader>wps <Plug>SaveWinPosn
"map <unique> <Leader>wpr <Plug>RestoreWinPosn

" Obviousmode plugin
let g:obviousModeInsertHi = 'term=reverse,bold ctermbg=88'
let g:obviousModeCmdwinHi = 'term=reverse,bold ctermbg=130'

" Imaps plugin (e.g. latex-suite)
imap <C-J> <Plug>IMAP_JumpForward
nmap <C-J> <Plug>IMAP_JumpForward
vmap <C-J> <Plug>IMAP_JumpForward

"}}}

" ---| FILETYPE PLUGINS |--- {{{

" RUBY
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" XML/HTML (xml.vim)
let html_use_css = 1
let xml_no_html = 1
let xml_use_xhtml = 1

" JAVA
autocmd Filetype java setlocal omnifunc=javacomplete#Complete 
autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
autocmd Filetype java inoremap <buffer> <C-X><C-U> <C-X><C-U><C-P>
autocmd Filetype java inoremap <buffer> <C-S-Space> <C-X><C-U><C-P> 

" }}}

" ---| FUZZYFINDER SETTINGS |--- {{{

let g:fuf_modesDisable = []
let g:fuf_mrufile_maxItem = 400
let g:fuf_mrucmd_maxItem = 400
nnoremap <silent> <leader>fj     :FufBuffer<CR>
nnoremap <silent> <leader>fk     :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <leader>fK     :FufFileWithFullCwd<CR>
nnoremap <silent> <leader>f<C-k> :FufFile<CR>
nnoremap <silent> <leader>fl     :FufCoverageFileChange<CR>
nnoremap <silent> <leader>fL     :FufCoverageFileChange<CR>
nnoremap <silent> <leader>f<C-l> :FufCoverageFileRegister<CR>
nnoremap <silent> <leader>fd     :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> <leader>fD     :FufDirWithFullCwd<CR>
nnoremap <silent> <leader>f<C-d> :FufDir<CR>
nnoremap <silent> <leader>fn     :FufMruFile<CR>
nnoremap <silent> <leader>fN     :FufMruFileInCwd<CR>
nnoremap <silent> <leader>fm     :FufMruCmd<CR>
nnoremap <silent> <leader>fu     :FufBookmarkFile<CR>
nnoremap <silent> <leader>f<C-u> :FufBookmarkFileAdd<CR>
vnoremap <silent> <leader>f<C-u> :FufBookmarkFileAddAsSelectedText<CR>
nnoremap <silent> <leader>fi     :FufBookmarkDir<CR>
nnoremap <silent> <leader>f<C-i> :FufBookmarkDirAdd<CR>
nnoremap <silent> <leader>ft     :FufTag<CR>
nnoremap <silent> <leader>fT     :FufTag!<CR>
nnoremap <silent> <leader>f<C-]> :FufTagWithCursorWord!<CR>
nnoremap <silent> <leader>f,     :FufBufferTag<CR>
nnoremap <silent> <leader>f<     :FufBufferTag!<CR>
vnoremap <silent> <leader>f,     :FufBufferTagWithSelectedText!<CR>
vnoremap <silent> <leader>f<     :FufBufferTagWithSelectedText<CR>
nnoremap <silent> <leader>f}     :FufBufferTagWithCursorWord!<CR>
nnoremap <silent> <leader>f.     :FufBufferTagAll<CR>
nnoremap <silent> <leader>f>     :FufBufferTagAll!<CR>
vnoremap <silent> <leader>f.     :FufBufferTagAllWithSelectedText!<CR>
vnoremap <silent> <leader>f>     :FufBufferTagAllWithSelectedText<CR>
nnoremap <silent> <leader>f]     :FufBufferTagAllWithCursorWord!<CR>
nnoremap <silent> <leader>fg     :FufTaggedFile<CR>
nnoremap <silent> <leader>fG     :FufTaggedFile!<CR>
nnoremap <silent> <leader>fo     :FufJumpList<CR>
nnoremap <silent> <leader>fp     :FufChangeList<CR>
nnoremap <silent> <leader>fq     :FufQuickfix<CR>
nnoremap <silent> <leader>fy     :FufLine<CR>
nnoremap <silent> <leader>fh     :FufHelp<CR>
nnoremap <silent> <leader>fe     :FufEditDataFile<CR>
nnoremap <silent> <leader>fr     :FufRenewCache<CR>

nnoremap <silent> <leader>fb     :FufBuffer<CR>
nnoremap <silent> <leader>ff     :FufFile<CR>


"}}}

