" NOTES : some maps may be unusable on some systems, that concerns :
" ù (ugrave), é (eacute), è (egrave), ç (ccedilla) or µ (mu)

" Last change: 2009 Dec 02


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

" Platforme
if has('macunix') || system('uname -o') =~? '^darwin'
  let g:PLATFORM = 'mac'
elseif has('win32unix')
  let g:PLATFORM = 'cygwin'
elseif has('win32') || has('win64')
  let g:PLATFORM = 'windows'
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
    set guioptions+=a "Gui visual w/ mouse (yank to "*)
    set guioptions+=c "Console dialogs (no popup)

    colorscheme ps_color
    "colorscheme twilight "Really nice colorscheme, like textmate
    "set guifont=Terminus:h14
else
	set termencoding=utf-8
	colorscheme desert
	set ttymouse=xterm2
	if (&term =~ 'screen-bce') " 256 color screen (condition is not safe)
	    set t_Co=256
	    set nocursorline
	    set nocursorcolumn
	elseif (&term =~ 'screen' || &term =~ 'linux')
	    set t_Co=16
	    set nocursorline
	    set nocursorcolumn
	else
	    set t_Co=256
	    set cursorline
	endif
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

" A deplacer au bon endroit
if g:PLATFORM =~ 'mac'
  " Sets the paths for Vim AND Python. Useful to get pythoncomplete to work
    function! SetPythonEnv()
	if has('python')
python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
	vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF
	endif

          "" F**KING Python 2.3 on MacVim
          ""python import vim, sys ; vim.command('set path+='+",".join(sys.path))
          ""set path+=/sw/lib/python26.zip,/sw/lib/python2.6,/sw/lib/python2.6/plat-darwin,/sw/lib/python2.6/plat-mac,/sw/lib/python2.6/plat-mac/lib-scriptpackages,/sw/lib/python2.6/lib-tk,/sw/lib/python2.6/lib-old,/sw/lib/python2.6/lib-dynload,/sw/lib/python2.6/site-packages
	  "set path+=/Library/Python/2.6
	  "python import vim, sys ; sys.path.extend(vim.eval('split(&path,",")'))
      "else
          "if (g:PLATFORM == 'mac')
              "set path+=/sw/lib/python26.zip,/sw/lib/python2.6,/sw/lib/python2.6/plat-darwin,/sw/lib/python2.6/plat-mac,/sw/lib/python2.6/plat-mac/lib-scriptpackages,/sw/lib/python2.6/lib-tk,/sw/lib/python2.6/lib-old,/sw/lib/python2.6/lib-dynload,/sw/lib/python2.6/site-packages
          "endif
      "endif
	set previewheight=16
    endfunction
    au FileType python call SetPythonEnv()
endif

" A deplacer au bon endroit
if g:PLATFORM =~ 'mac'
  autocmd FileType ocaml,caml,omlet let Tlist_Ctags_Cmd = '~/scripts/linux/octags.sh'
endif

"}}}

" ---| GLOBAL SETTINGS |--- {{{

" Indentation and tabs
set autoindent "Indent (based on above line) when adding a line
set ts=8 "A tab is 8 spaces
set softtabstop=4 "See 4 spaces per tab
set sw=4 "Indent is 4
set nosmartindent "Cindent is better

" Editing layout
set formatoptions+=ln "See :h 'formatoptions' :)
set backspace=start,indent,eol "Fix backspace
set linebreak "Break lines at words, not chars
set scrolloff=4 "When moving vertical, start scrolling 4 lines before reaching bottom
set modeline "Vim mini-confs near end of file
set listchars+=tab:>-,trail:·,extends:~,nbsp:¤
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
set updatetime=2000 "Update swap (and showmark plugin) every 2 sec

" Windows and buffers
set splitright " Vsplit at right
set previewheight=8 "Height of preview menu (Omni-completion)
"set hidden "To move between buffers without writing them.  Don't :q! or :qa! frivolously!

" Command mode options
set wildmenu "Completions view in ex mode (super useful !)
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.ps,*.pdf,*.cmo,*.cmi,*.cmx "Don't complete bin files
set cmdheight=1 "Command line height
set laststatus=2 "When to show status line (2=always)
set ruler "Show line,col in statusbar
set number "Show lines
set showmode "Show mode in status (insertion, visual...)
set showcmd "Show beginning of normal commands (try d and see at bottom-right)


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

" Updates 'Last change(s):' ; called on every buffer saving 
function! TimeStamp()
  let lines = line("$") < 10 ? line("$") : 10
  let pattern1 = '\([Ll]ast [Cc]hanges\=\s\=:\s*\)\d\d\d\d \w[a-zé][a-zû] \d\d'
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




"}}}

" ---| MAPPINGS |--- {{{

"" HANDY MAPPINGS 

" Much better :) hope it doesn't crash any plugin
map Y y$
" Next window
map - <c-w>w
" Remove search hilights
map __ :noh<CR>
" correct this shitty typo on exit :]
nmap q: :q

" For azerty layouts
map! ù <leader>
map! ² <leader>
nnoremap ' `
map § :e#<cr>

" For qwerty/azerty pain-in-the-ass typos
map Q A
imap   \<espace insécable\>

" Search for visually selected pattern
vmap * :<C-U>let old_reg=@"<cr>gvy/<C-R><C-R>=substitute(escape(@",'\/.*$^~[]'),"\n$","","")<CR><CR>:let @"=old_reg<cr>n

" Search for visually selected pattern
vmap # :<C-U>let old_reg=@"<cr>gvy/<C-R><C-R>=substitute(escape(@",'\/.*$^~[]'),"\n$","","")<CR><CR>:let @"=old_reg<cr>N


"" FUNCTION KEYS (used: 4 6 7 8 10 11 12)

" Tabs
map <F4> :tabnew<cr>:e 

"Preview zone F6/7/8
map <F6> :pop<cr>
map <F7> :tag<cr>
map <F8> :pc<cr>
"Quickfix zone Shift + F6/7/8
map <S-F6> :cp<cr>
map <S-F7> :cn<cr>
map <S-F8> :ccl<cr>

" Tags update
map <F12> :!ctags -R .<CR><CR>
" Toggle 'preview' in omni-completion
map <C-F12> :let &completeopt = (&completeopt == "menu" ? "menu,preview" : "menu") <bar> echo &completeopt <cr>


"" REDEFINITIONS 

" So that the search result is in the middle of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" Fixes a bit Scrolling
"nnoremap <PageUp> zz<PageUp>zz
"nnoremap <PageDown> zz<PageDown>zz


" Navigate between tabs
nnoremap ` :tabnext<cr>
nnoremap <space> :tabprev<cr>

nnoremap <cr> :bn<cr>
nnoremap <bs> :bp<cr>

" A good trick to take the hjkl-use habit
nmap <left> :echo "Left is 'h' !"<cr>
nmap <down> :echo "Down is 'j' !"<cr>
nmap <up> :echo "Up is 'k' !"<cr>
nmap <right> :echo "Right is 'l' !"<cr>

" Forgot to sudo ? Hehee :)
command WW w !sudo tee % > /dev/null
command W w "Normal write (useful w/ qwerty's semi-colon)


"" Misc (maps using <leader>)

" Set paste
map <leader>sp :set paste!<cr>

" Spell checking
map <leader>st :setlocal spell! spelllang=en spellcapcheck=<cr>
map <leader>sc :setlocal nospell<cr>
map <leader>sd :setlocal spell spelllang=de spellcapcheck=<cr>
map <leader>se :setlocal spell spelllang=en spellcapcheck=<cr>
map <leader>sf :setlocal spell spelllang=fr spellcapcheck=<cr>

" PDF
"Transforms ´e into é etc.. for cp/paste from bad pdf files
map <leader>pa :s/´e/é/ge<bar>s/`e/è/ge<bar>s/[ˆ^]e/ê/ge<bar>s/`a/à/ge<bar>s/[ˆ^]o/ô/ge<bar>s/[ˆ^]i/î/ge<cr>

" Vim
map <leader>vht :helptags ~/.vim/doc
map <leader>vev :e ~/.vimrc
map <leader>vtv :tabnew ~/.vimrc
map <leader>vsv :so ~/.vimrc

" Qwerty mappings
if g:PLATFORM =~ 'mac'
    noremap! ß é
    noremap! ∂ ê
    noremap! ƒ è
    noremap! µ ù
endif

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

" ---| FILETYPE |--- {{{

" Keyword dictionary complete
"autocmd FileType * exec('setlocal dict+='.$VIMRUNTIME.'/syntax/'.expand('<amatch>').'.vim')

set tags=./TAGS,TAGS,./tags,tags

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  'z
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
source $HOME/.vim/sitaktif/plugin_vimrc.vim

" Autocorrections
source $HOME/.vim/sitaktif/autocorrect_fr_vimrc.vim

" Vim Outliner plugin
source $HOME/.vim/sitaktif/vo_vim_outliner.vim

" Temporary mappings and settings
source $HOME/.vim/sitaktif/temp_mappings.vim

"}}}
