" ---| BASIC HEADER |--- {{{

"Removes vi-compatibility (mandatory !)
set nocp

" Pathogen conf
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" File types and coloration have to be set here
syntax on
filetype plugin on
filetype indent on
set background=dark

" Temporary fix to avoid a deprecation warning on 'import imp' in python3
if has('python3')
  silent! python3 1
endif

"}}}

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

if has("gui_running") " GUI mode
    let &guicursor = &guicursor . ",a:blinkon0"
    set guioptions-=e "No gui-like tabs
    set guioptions-=T "No toolbar
    set guioptions-=m "No menubar
    set guioptions-=r "No scroolbar (right)
    set guioptions-=L "No scroolbar (left)
    set guioptions+=c "Console dialogs (no popup)
    "set guioptions+=a "Gui visual w/ mouse (yank to "*)

    colorscheme molokai

    if g:PLATFORM =~ "win"
        set guifont=Terminus:h12
    elseif g:PLATFORM =~ "mac"
        set guifont=
    else
        set guifont=Terminus\ 12
    endif
elseif has('gui') " A terminal with GUI support
	colorscheme ps_color
	set termencoding=utf-8
else
    colorscheme hybrid
    set termencoding=utf-8
    if g:PLATFORM =~ "mac"
        set t_ZH=[3m t_ZR=[23m " Set the italics code
    endif
endif

" Highlight current line, no underline/bold/whatnot
set cursorline
hi CursorLine cterm=NONE term=NONE

" Orgmode multi-star should show only last star
hi link org_shade_stars NonText

"Omni menu colors
hi Pmenu guibg=#333333 ctermbg=black
hi PmenuSel guibg=#555555 guifg=#ffffff

if (&term =~ 'rxvt') "Vieux hack rxvt (...)
    so ~/.vim/sitaktif/rxvt.vim
end

"}}}

" ---| PLUGIN SETTINGS |--- {{{

" Vundle config
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" let Vundle manage Vundle, required
Plug 'VundleVim/Vundle.vim'

" General plugins
Plug 'tpope/vim-surround'
Plug 'kana/vim-fakeclip'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-obsession'
Plug 'sitaktif/vim-space'
Plug 'git://github.com/majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'godlygeek/tabular'
Plug 'rking/ag.vim'
Plug 'rizzatti/dash.vim'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating' " Increase/decrease date with <C-a>/<C-x>
Plug 'tpope/vim-unimpaired'
Plug 'tommcdo/vim-exchange'
Plug 'ciaranm/detectindent'
Plug 'ap/vim-readdir' " Simpler browser
Plug 'tpope/vim-abolish' " :Subvert (substitute with case preserve) and 'coerce to different casing' with crX: MixedCase (crm), camelCase (crc), snake_case (crs), UPPER_CASE (cru), dash-case (cr-), dot.case (cr.), space case (cr<space>), and Title Case (crt)
Plug 'ctrlpvim/ctrlp.vim' " File finder
Plug 'terryma/vim-expand-region' " Incremental selection (like ctrl-w in IDEA)
Plug 'kana/vim-textobj-user' " requirement for textobj plugins
Plug 'kana/vim-textobj-line' " vil --> visual inner line
Plug 'mhinz/vim-grepper' " Proper grepping plugin?

" Color
Plug 'scwood/vim-hybrid'

" FT Plugs
Plug 'vim-syntastic/syntastic'
Plug 'neomake/neomake'
Plug 'hynek/vim-python-pep8-indent'
Plug 'elixir-lang/vim-elixir'
Plug 'kballard/vim-swift'
Plug 'plasticboy/vim-markdown'
Plug 'kylef/apiblueprint.vim'
Plug 'nvie/vim-rst-tables'
Plug 'honza/vim-snippets'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Python
Plug 'alfredodeza/pytest.vim'
Plug 'python-rope/ropevim'
Plug 'davidhalter/jedi-vim'

" Initialize plugin system
call plug#end()

"  }}}

" ---| GLOBAL SETTINGS |--- {{{

" Indentation and tabs
set autoindent "Indent (based on above line) when adding a line
set tabstop=2 "A tab is worth 2 spaces
set softtabstop=2 "See 2 spaces per tab
set expandtab "Use spaces instead of tabs
set shiftwidth=2 "Indent is 2
set shiftround
set nosmartindent "Cindent is better (it is set in ftplugin)
set cinkeys-=0# " Otherwise, it prevents '#' from being indented
set indentkeys-=0#

" Editing layout
set formatoptions+=ln "See :h 'formatoptions' :)
set backspace=start,indent,eol "Fix backspace
set linebreak "Break lines at words, not chars
set scrolloff=4 "When moving vertical, start scrolling 4 lines before reaching bottom
set modeline "Vim mini-confs near end of file
set modelines=5
set listchars+=tab:>-,trail:·,extends:~,nbsp:-
set fileformats+=mac
set nojoinspaces
set nostartofline "Don't move the cursor to start of line after a command

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
set previewheight=20 "Height of preview menu (Omni-completion)
set hidden "To move between buffers without writing them.  Don't :q! or :qa! frivolously!

" Command mode options
set wildmenu "Completions view in ex mode (super useful !)
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.ps,*.pdf,*.cmo,*.cmi,*.cmx "Don't complete bin files
set cmdheight=1 "Command line height
set laststatus=2 "When to show status line (2=always)
" Set statusline - silently fail if vim lacks version / plugins
set statusline=%F%m%r%h%w\%=[%4l/%-4L\ %3v]\ [%p%%]
if (v:version >= 700)
    set statusline=%F%m%r%h%w\%=[%4l/%-4L\ %3v/%-3{len(getline('.'))}]\ [%p%%]
    silent! call fugitive#statusline() " We have to call it first in order to test existence
    if exists('*fugitive#statusline')
	set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ \%=\ [%4l/%-4L\ %3v/%-3{len(getline('.'))}]\ [%p%%]
    endif
endif
set ruler "Show line,col in statusbar
set number "Show lines
set showmode "Show mode in status (insertion, visual...)
set showcmd "Show beginning of normal commands (try d and see at bottom-right)

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.job

" TODO: This is a try. See if it is ok
set tags=tags,./tags,../tags,../../tags

" Auto-folding and auto-layout (e.g. for vim help files)
" TODO: do it by filetype
set foldenable "Automatic folding
set foldmethod=marker "Folds automatically between {{{ and }}}

" Mouse
set mouse=a "Use mouse (all)
if !has('nvim')
    set ttymouse=xterm2 "Mouse dragging in iTerm
endif

"}}}

" ---| MORE COMPLEX FUNCTIONS |--- {{{
"

" Open selected text with native open command, used with `<Leader>o` mappings.
" This is an operator pending map
function! OpenUrl(type)
  if a:type ==# 'v'| execute "normal! `<v`>y"| " If in charwise visual mode, copy selected URL.
  elseif a:type ==# 'char'| execute "normal! `[v`]y"| " If given a text object URL, copy it.
  else| return
  endif

  " This doesn't work with /usr/bin/vim on macOS (doesn't identify as macOS).
  if has('mac')| let openCmd = 'open'| else| let openCmd = 'xdg-open'| endif
    silent execute "! " . openCmd . " " . shellescape(@@, 1)| " Escape URL and pass as arg to open command.
    echo openCmd . " " shellescape(@@, 1)| " Echo what we ran so it's visible.
endfunction

nnoremap <Leader>o :set operatorfunc=OpenUrl<CR>g@
vnoremap <Leader>o :<c-u>call OpenUrl(visualmode())<CR>

if !exists(":DiffOrig")
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

func! DeleteTrailingWS()
    let lnum = line(".")
    let cnum = col(".")
    silent! keepjumps %s/\s\+$//ge
    silent! keepjumps call cursor(lnum, cnum)
endfunc
autocmd BufWrite *.sh,*.bash,*.java,*.py,*.rb,*.h,*.hpp,*.c,*.cpp,*.md,*.rst :call DeleteTrailingWS()

"}}}

" ---| MAPPINGS |--- {{{

"" HANDY MAPPINGS

" Single quote is sufficient (I use backquote for tabnext)
noremap ' `

" Select last pasted text
nnoremap gp `[v`]

" Next window
" map - <c-w>w
" Remove search hilights
map - :noh<CR>
" Format each line individually (useful for git commits)
nmap gQ :g/^[^#]/norm gqq<cr>

" No more 'fu-, gotta make a `!rm ./1` :( '
cabbr w1 :w!
cabbr q1 :q!
command! W w
command! Wq wq
command! WQ wq
command! E e
command! Q q

" Make it obvious when a non-space-blank is inserted
imap   \<non_space_blank\>

"" FUNCTION KEYS (used: 1 4 6 7 8 10 11 12) - TODO

" Tabs
map <F3> :A<cr>
" map <F2> to something PREV
" map <F3> to something NEXT
map <F4> :tabe

"map <F5> :!%

""Preview zone F6/7/8
"map <F6> :pop<cr>
"map <F7> :tag<cr>
"map <F8> :pc<cr>
""Quickfix zone Shift + F6/7/8
"map <S-F6> :cp<cr>
"map <S-F7> :cn<cr>
"map <S-F8> :ccl<cr>

"" Tags update
"map <F12> :!ctags -R .<CR><CR>
"" Toggle 'preview' in omni-completion
"map <C-F12> :let &completeopt = (&completeopt == "menu" ? "menu,preview" : "menu") <bar> echo &completeopt <cr>


"" REDEFINITIONS

" Warning:
" The following may be a bit hardcore for beginners...

" Navigate between tabs
" nnoremap ` :tabnext<cr>
" nnoremap <space> :tabprev<cr>

" ...and between buffers.
nnoremap <return> :bn<cr>
nnoremap <bs> :bp<cr>

" Use arrows to move the screen (not the cursor).
" Cursor should be moved with hjkl.
" noremap <up> 10<c-y>
" noremap <down> 10<c-e>
" noremap <left> 10zh
" noremap <right> 10zl


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

" Set paste
noremap <leader>sp :set paste!<cr>

" Set number
noremap <leader>sn :set number!<cr>

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

" Vim
noremap <leader>vev :e ~/.vimrc<cr>
noremap <leader>vsv :so ~/.vimrc<cr>
exec "map <leader>vht :helptags ".s:config_path."/doc<cr>"

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


" Fold non-search content to only display the search (super tip!)
nnoremap g/ :call SitaShowSearchOnly()<cr>
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
" map <leader>pa :s/´e/é/ge<bar>s/`e/è/ge<bar>s/[ˆ^]e/ê/ge<bar>s/`a/à/ge<bar>s/[ˆ^]o/ô/ge<bar>s/[ˆ^]i/î/ge<cr>

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

" ---| ABBREVIATIONS |--- {{{

" They are not that useful in practice, I found :-)

"}}}

" ---| AUTOCOMMANDS |--- {{{

" Keyword dictionary completion with syntax
autocmd FileType * exec('setlocal dict+='.$VIMRUNTIME.'/syntax/'.expand('<amatch>').'.vim')


" always jump back to the last position when re-entering a file
if has("autocmd")
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
endif

"}}}

" ---| FILETYPE |--- {{{
" Small confs only. Big ones are in ~/.vim/ftplugin

" Python
au FileType python set omnifunc=pythoncomplete#Complete

" Javascript
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

" CSS [Works so good :)]
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" PHP
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" Vim files
autocmd FileType vim map <buffer> <f5> :so %<cr>

" HTML
"Jump to end of tag
autocmd FileType html,htmldjango,xml,xhtml imap <c-l> <esc>l%a

" Mutt (mail client)
au BufRead /tmp/mutt-* set tw=72 spell

" Shell / Bash
au FileType sh set iskeyword-=.

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
