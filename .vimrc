" NOTES : some maps may be unusable on some systems, that concerns :
" ù (ugrave), é (eacute), è (egrave), ç (ccedilla) or µ (mu)

" Last changes: 2009 Dec 02


"Removes vi-compatibility (mandatory !)
set nocp

" Pathogen conf
filetype off
call pathogen#runtime_append_all_bundles()

" File types and coloration have to be set here
syntax on
filetype plugin on
filetype indent on
set background=dark

au BufRead,BufNewFile *py syntax on

" ---| SYSTEM-DEPENDANT SETTINGS |--- {{{

" Platform
let s:path = expand('<sfile>:p:h')
let s:config_path = s:path . '/.vim'
if has('macunix') || system('uname -o') =~? '^darwin'
    let g:PLATFORM = 'mac'
elseif has('win32unix')
    let g:PLATFORM = 'cygwin'
elseif has('win32') || has('win64')
    let g:PLATFORM = 'win'
    let s:config_path = s:path . '/vimfiles'
else
    let g:PLATFORM = 'other'
endif

" If GUI mode
if has("gui_running")
    let &guicursor = &guicursor . ",a:blinkon0"
    set guioptions-=e "No gui-like tabs
    set guioptions-=T "No toolbar
    set guioptions-=m "No menubar
    set guioptions-=r "No scroolbar (right)
    set guioptions-=L "No scroolbar (left)
    set guioptions+=c "Console dialogs (no popup)
    "set guioptions+=a "Gui visual w/ mouse (yank to "*)

    colorscheme ps_color

    if g:PLATFORM =~ "win"
	set guifont=Terminus:h12
    elseif g:PLATFORM =~ "mac"
	set guifont=
    else
	set guifont=Terminus:h14
    endif
else
	colorscheme desert
	set termencoding=utf-8
	set ttymouse=xterm2
	"if (&term =~ 'screen-bce') " 256 color screen (condition is not safe)
	    "set t_Co=256
	    "set nocursorcolumn
	"elseif (&term =~ 'screen' || &term =~ 'linux')
	    "set t_Co=16
	    "set nocursorcolumn
	"else
	    "set t_Co=256
	"endif
endif

" Highlight current line
set cursorline
hi CursorLine guibg=#333333

"Omni menu colors
hi Pmenu guibg=#333333 ctermbg=black
hi PmenuSel guibg=#555555 guifg=#ffffff

if (&term =~ 'rxvt') "Vieux hack rxvt (...)
    so ~/.vim/sitaktif/rxvt.vim
end

" A deplacer au bon endroit - et a corriger aussi /!\
" A deplacer au bon endroit - et a corriger aussi /!\
" A deplacer au bon endroit - et a corriger aussi /!\
if g:PLATFORM =~ 'mac'
au FileType python set path +=/sw/lib/python2.6/site-packages/Django-1.2.3-py2.6.egg
"""   " Sets the paths for Vim AND Python. Useful to get pythoncomplete to work
"""     function! SetPythonEnv()
""" 	if has('python')
""" python << EOF
""" import os
""" import sys
""" import vim
""" for p in sys.path:
"""     if os.path.isdir(p):
""" 	vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
""" EOF
""" 	endif
""" 
"""           "" F**KING Python 2.3 on MacVim
"""           ""python import vim, sys ; vim.command('set path+='+",".join(sys.path))
"""           ""set path+=/sw/lib/python26.zip,/sw/lib/python2.6,/sw/lib/python2.6/plat-darwin,/sw/lib/python2.6/plat-mac,/sw/lib/python2.6/plat-mac/lib-scriptpackages,/sw/lib/python2.6/lib-tk,/sw/lib/python2.6/lib-old,/sw/lib/python2.6/lib-dynload,/sw/lib/python2.6/site-packages
""" 	  "set path+=/Library/Python/2.6
""" 	  "python import vim, sys ; sys.path.extend(vim.eval('split(&path,",")'))
"""       "else
"""           "if (g:PLATFORM == 'mac')
"""               "set path+=/sw/lib/python26.zip,/sw/lib/python2.6,/sw/lib/python2.6/plat-darwin,/sw/lib/python2.6/plat-mac,/sw/lib/python2.6/plat-mac/lib-scriptpackages,/sw/lib/python2.6/lib-tk,/sw/lib/python2.6/lib-old,/sw/lib/python2.6/lib-dynload,/sw/lib/python2.6/site-packages
"""           "endif
"""       "endif
""" 	set previewheight=16
"""     endfunction
"""     au FileType python call SetPythonEnv()
""" endif
""" 
""" " A deplacer au bon endroit
""" if g:PLATFORM =~ 'mac'
"""   autocmd FileType ocaml,caml,omlet let Tlist_Ctags_Cmd = '~/scripts/linux/octags.sh'
endif


" ---| GLOBAL SETTINGS |--- {{{

" Indentation and tabs
set autoindent "Indent (based on above line) when adding a line
set tabstop=8 "A tab is 8 spaces
set softtabstop=4 "See 4 spaces per tab
set shiftwidth=4 "Indent is 4
set shiftround
set nosmartindent "Cindent is better
set cindent

" Editing layout
set formatoptions+=ln "See :h 'formatoptions' :)
set backspace=start,indent,eol "Fix backspace
set linebreak "Break lines at words, not chars
set scrolloff=4 "When moving vertical, start scrolling 4 lines before reaching bottom
set modeline "Vim mini-confs near end of file
set listchars+=tab:>-,trail:·,extends:~,nbsp:-
set fileformats+=mac

" Search
set wrapscan "Continue to top after reaching bottom
set hlsearch "Highlight search
set incsearch "See results of search step by step
set ignorecase
set smartcase "Do not ignore case if there is a MAJ in pattern

" Parenthesis
set showmatch "Parenthesis matches
set matchtime=2 "Show new matching parenthesis for 2/10th of sec

" System
set vb t_vb="" "Removes the Fucking Bell Of Death...
set history=1024 "Memorize 1024 last commands
set updatetime=1000 "Update swap (and showmark plugin) every 1 sec

" Windows and buffers
set splitright " Vsplit at right
set previewheight=8 "Height of preview menu (Omni-completion)
set hidden "To move between buffers without writing them.  Don't :q! or :qa! frivolously!

" Command mode options
set wildmenu "Completions view in ex mode (super useful !)
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.ps,*.pdf,*.cmo,*.cmi,*.cmx "Don't complete bin files
set cmdheight=1 "Command line height
set laststatus=2 "When to show status line (2=always)
set statusline=%F%m%r%h%w\ %Y\ [%03.3b\ %02.2B]\ [L=%04l/%L,C=%04v/%{len(getline('.'))}]\ [%p%%]
set ruler "Show line,col in statusbar
set number "Show lines
set showmode "Show mode in status (insertion, visual...)
set showcmd "Show beginning of normal commands (try d and see at bottom-right)

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.job

set tags=./tags;/

" Statusline
" function! CurDir()
"   let curdir = substitute(getcwd(), $HOME, "~", "g")
"   return curdir
" endfunction
"set statusline=\ %n\ %-30.50(%f\ %m%r%w%)\ [%{CurDir()}]\ \ \ %28.60({%Y}\ \ \ l/%L\ (%P)\ \ :%c%)

" Auto-folding and auto-layout (e.g. for vim help files)
set foldenable "Automatic folding
"TODO: do it by filetype
set foldmethod=marker "Folds automatically between {{{ and }}}

" Mouse
set mouse=a "Use mouse (all)
set ttymouse=xterm2 "Mouse dragging in iTerm

"}}}

" ---| MORE COMPLEX FUNCTIONS |--- {{{
"
"  TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO

" Updates 'Last change(s):' ; called on every buffer saving 
function! TimeStamp()
  let lines = line("$") < 10 ? line("$") : 10
  let pattern1 = '\([Ll]ast [Cc]hanges\=\s\=:\)'
  let replace1 = '\1' . strftime("%Y %b %d")
  " First n lines
  execute printf('silent! 1,%ds/\C\m%s/%s/e', lines, pattern1, replace1)
  " Last n lines
  execute printf('silent! $-%d+1,$s/\C\m%s/%s/e', lines, pattern1, replace1)
  "let pattern2 = '\($Id: \f\+ \d\+\.\d\+\(\.\d\+\.\d\+\)*\)\(+\(\d\+\)\)\? '
  "           \ . '\(\d\d\d\d[-/]\d\d[-/]\d\d \d\d:\d\d:\d\d\)\(+\d\d\)\?'
  "let replace2 = '\=submatch(1) . "+" . (submatch(4) + 1) . " "'
  "           \ . '. strftime("%Y\/%m\/%d %H:%M:%S") . submatch(6)'
  "execute printf('1,%ds/\C\m%s/%s/e', lines, pattern2, replace2)
  "execute printf('$-%d+1,$s/\C\m%s/%s/e', lines, pattern2, replace2)
endfunction

" Try this new one, one day (merge with previous one) :
"" Last Modified: Wed 14 Oct 2009 09:44:38 AM CDT 
	function! UpdateLastModified() 
	  if &modified 
	    let save_cursor = getpos(".") 
	    "let save_substitute = " CANNOT MANAGE TO RECOVER THE LAST
		"SUBSTITUTE (for &, :&, etc..)
"	    silent! keepjumps 1,4s/ Last Modified: \zs.*/\=strftime('%c')/ )
	    silent! undojoin keepjumps 1,4s/\([Ll]ast [Cc]hanges\=\s\=:\s*\)\zs\d\d\d\d \w[a-zé][a-zû] \d\d\ze/\=strftime('%Y %b %d')/

	    call setpos('.', save_cursor) 
	  endif 
	endfunction 
	autocmd BufWritePre * call UpdateLastModified()  

"  TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO

"}}}

" ---| MAPPINGS |--- {{{

"" HANDY MAPPINGS 

" Single quote is sufficient (I use backquote for tabnext)
noremap ' `
" Much better :) hope it doesn't crash any plugin
nnoremap Y y$
nnoremap gp `[v`]

" Next window
map - <c-w>w
" Remove search hilights
map _ :noh<CR>
" correct this shitty typo on exit :]
nmap q: :q
" No more 'fu-, gotta make a `!rm ./1` :( '
cabbr w1 :w!
cabbr q1 :q!

" For azerty layouts
" map! ù <leader>
" map! ² <leader>
" map § :e#<cr> " TODO: try with CTRL-6

" For qwerty/azerty pain-in-the-ass typos
map Q A
imap   \<espace insécable\>



"" FUNCTION KEYS (used: 4 6 7 8 10 11 12) - TODO

" Tabs
map <F1> :A<cr>
" map <F2> to something PREV
" map <F3> to something NEXT
map <F4> :tabe 

""Preview zone F6/7/8
"map <F6> :pop<cr>
"map <F7> :tag<cr>
"map <F8> :pc<cr>
""Quickfix zone Shift + F6/7/8
"map <S-F6> :cp<cr>
"map <S-F7> :cn<cr>
"map <S-F8> :ccl<cr>
"
"" Tags update
"map <F12> :!ctags -R .<CR><CR>
"" Toggle 'preview' in omni-completion
"map <C-F12> :let &completeopt = (&completeopt == "menu" ? "menu,preview" : "menu") <bar> echo &completeopt <cr>


"" REDEFINITIONS 

" So that the search result is in the middle of the screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Warning:
" The following may be a bit hardcore for beginners...

" Navigate between tabs
nnoremap ` :tabnext<cr>
nnoremap <space> :tabprev<cr>

" ...and between buffers
nnoremap <return> :bn<cr>
nnoremap <bs> :bp<cr>

noremap <up> 10<c-y>
noremap <down> 10<c-e>
noremap <left> 10zh
noremap <right> 10zl


" Beginners that want to have a good habit 
" (i.e. use hjkl instead of <left>,<down>,<up>,<right>) can use:

" A good trick to take the hjkl-use habit
"nmap <left> :echo "Left is 'h' !"<cr>
"nmap <down> :echo "Down is 'j' !"<cr>
"nmap <up> :echo "Up is 'k' !"<cr>
"nmap <right> :echo "Right is 'l' !"<cr>


" Forgot to sudo ? Hehee :)
if g:PLATFORM != 'win'
    command! WW w !sudo tee % > /dev/null
endif


"" Misc (maps using <leader>)

" Set paste
noremap <leader>sp :set paste!<cr>

" Set number
noremap <leader>sn :set number!<cr>
noremap <leader>sN :silent! windo set number!<cr>

" Diff
noremap <leader>vd :diffthis<cr>
noremap <leader>vD :windo diffthis<cr>
noremap <leader>vo :diffoff<cr>
noremap <leader>vO :windo diffoff<cr>

" Set list and wrap
noremap <leader>sl :set list!<cr>
noremap <leader>sw :set wrap!<cr>

" Spell checking
noremap <leader>st :setlocal spell! spelllang=en spellcapcheck=<cr>
noremap <leader>sc :setlocal nospell<cr>
noremap <leader>se :setlocal spell spelllang=en spellcapcheck=<cr>
noremap <leader>sf :setlocal spell spelllang=fr spellcapcheck=<cr>
noremap <leader>sd :setlocal spell spelllang=de spellcapcheck=<cr>

" Search for visually (multiline) selected text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>


" Fold non-search content (super tips !)
nnoremap <leader>/ :call SitaShowSearchOnly()<cr>
function! SitaShowSearchOnly()
    if &foldmethod == "manual"
	echomsg "Cannot use the functionality with foldmethod == \"manual\"."
	echomsg "Change your settings first (set foldmethod=marker for example)"
	return
    endif
    if exists("b:bak_foldmethod") && exists("b:bak_foldexpr")
	exec("setlocal foldmethod=".b:bak_foldmethod." foldexpr=".b:bak_foldexpr)
	exec("setlocal foldlevel=".b:bak_foldlevel." foldcolumn=".b:bak_foldcolumn)
	unlet b:bak_foldmethod b:bak_foldexpr
	unlet b:bak_foldlevel b:bak_foldcolumn
    else
	let b:bak_foldlevel=&foldlevel
	let b:bak_foldcolumn=&foldcolumn
	let b:bak_foldmethod=&foldmethod
	let b:bak_foldexpr=&foldexpr
	setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-2)=~@/)\|\|(getline(v:lnum+2)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2
    endif
endfunc


" PDF
"Transforms ´e into é etc.. for cp/paste from bad pdf files
map <leader>pa :s/´e/é/ge<bar>s/`e/è/ge<bar>s/[ˆ^]e/ê/ge<bar>s/`a/à/ge<bar>s/[ˆ^]o/ô/ge<bar>s/[ˆ^]i/î/ge<cr>

" Vim
noremap <leader>vpf :echo expand('%')<cr>
noremap <leader>vev :e ~/.vimrc<cr>
noremap <leader>vtv :tabnew ~/.vimrc<cr>
noremap <leader>vsv :so ~/.vimrc<cr>
exec "map <leader>vht :helptags ".s:config_path."/doc<cr>"

" Qwerty mappings
if g:PLATFORM =~ 'mac'
    noremap! ß é
    noremap! ∂ ê
    noremap! ƒ è
    noremap! µ ù
endif

" Fix the shift-backspace problem
noremap!  <bs>

"}}}

" ---| AUTOCOMMANDS |--- {{{

" ks is an alias for :mark s
"autocmd BufWritePre *  silent! undojoin | normal mz | call TimeStamp()|normal `z
"autocmd BufWritePre *  silent! undojoin | call TimeStamp()

" always jump back to the last position when re-entering a file
if has("autocmd")
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
endif

"}}}

" TODO TODO TODO
" TODO TODO TODO put that in the right files !
" TODO TODO TODO
" ---| FILETYPE |--- {{{

" Keyword dictionary complete
autocmd FileType * exec('setlocal dict+='.$VIMRUNTIME.'/syntax/'.expand('<amatch>').'.vim')

set tags=./TAGS,TAGS,./tags,tags

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal 'z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

" OCamL
autocmd FileType ocaml,caml,omlet setlocal suffixesadd=.ml,.mli
autocmd FileType ocaml,caml,omlet setlocal includeexpr=substitute(v:fname,'.','\\l&','g')
autocmd FileType ocaml,caml,omlet let g:tlist_def_ocaml_settings = 'ocaml;m:module;t:type;d:definition'
autocmd FileType ocaml,caml,omlet nmap <F5> :!ocaml <cfile><CR>
"autocmd FileType ocaml,caml,omlet let Tlist_Ctags_Cmd = '/usr/local/bin/otags'
"autocmd FileType 


" Javascript
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

" CSS [Works so good :)]
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" PHP
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" C / C++ (OmniCppComplete)
autocmd FileType c,cpp map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Vim files
autocmd FileType vim map <buffer> <f5> :so %<cr>

" JAVA
" See ftplugin/java.vim
"autocmd FileType java 

" HTML
"Jump to end of tag
autocmd FileType html,htmldjango,xml,xhtml imap <c-l> <esc>l%a

" RUBY
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" Django (ca fout la merde, TODO: régler ca)
"autocmd FileType htmldjango imap {% {%  %}<esc>2hi
"autocmd FileType htmldjango imap <leader>b <esc>:s/{% block \(.*\) %}/&\r{% endblock \1 %}<cr>:noh<cr>O
"autocmd FileType htmldjango imap <leader>e <esc>:s/{% \([a-zA-Z]\+\) \(.*\) %}/&\r{% end\1 \2 %}<cr>:noh<cr>O
"cmap ftd set filetype=htmldjango<cr>

" Prototype (js framework) :
"Useful only for azerty
"imap $ù $('')<esc>hi

" Mutt (mail client)
au BufRead /tmp/mutt-* set tw=72 spell

" XML
com! XMLClean 1,$!xmllint --format -

"}}}

" ---| INCLUDES |--- {{{

" Plugin-dependant settings
exec 'source ' . s:config_path . '/sitaktif/plugin_vimrc.vim'

" Autocorrections
exec 'source ' . s:config_path . '/sitaktif/autocorrect_fr_vimrc.vim'
exec 'source ' . s:config_path . '/sitaktif/autocorrect_en_vimrc.vim'

"}}}
