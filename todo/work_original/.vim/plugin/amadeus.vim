" Vim global plugin for Amadeus
" Last Change:  2011 Feb 01
" Maintainer:   Romain Chossart <romainchossart@gmail.com>
" License:	This plugin is the property of Amadeus Services Ltd.

" Note: Use "za" keystrokes to alternate folding below.

"echomsg "Amadeus.vim general plugin loading..."

" INIT {{{

if version < 700
    echomsg 'Your version of Vim is < 7.0. Cannot load Amadeus plugin.'
    echomsg 'Please add export PATH="/data/softs/bin:$PATH" to your .zshrc.'.$USER
    finish
endif

if !exists('g:AMA_USER_TEAM')
    echohl WarningMsg
    echomsg "Your team has not been set. Please set it by adding e.g. let g:AMA_USER_TEAM = 'stg'"
    echomsg "  in your ~/.vimrc file."
    echohl None
    "let dummy = input("Press ENTER to continue")
    finish
endif

"if !exists('g:AMA_FIRST_TIME_OCCURED')
"    let g:AMA_FIRST_TIME_OCCURED = "Yes !"
"    echomsg "Current team is ".g:AMA_USER_TEAM.". If not, modify your ~/.vimrc."
"    echomsg "Add  let g:AMA_FIRST_TIME_OCCURED=1  to your ~/.vimrc to remove message."
"endif

" }}}

" CONSTANTS (may vary sometimes though :) ) {{{

" List of all the packages
let g:AMA_CM_ALL_PKGS = ['acc', 'afw', 'ams', 'apq', 'bld', 'bmt', 'brd', 'bzr']
let g:AMA_CM_ALL_PKGS += ['cds', 'cfa', 'cmp', 'cmt', 'com', 'cpr', 'crp', 'cry']
let g:AMA_CM_ALL_PKGS += ['ctp', 'dba', 'ehb', 'etk', 'exq', 'fli', 'fmc', 'fmt']
let g:AMA_CM_ALL_PKGS += ['hfw', 'hst', 'hub', 'idc', 'inv', 'lst', 'ola', 'onl']
let g:AMA_CM_ALL_PKGS += ['pag', 'pay', 'pcv', 'prt', 'qdm', 'reg', 'rgd', 'sct']
let g:AMA_CM_ALL_PKGS += ['sec', 'smt', 'swp', 'syn', 'tci', 'www']

" TODO: A BUNCH ARE MISSING, TRY TO COMPLETE THE LIST
" Missing
" afw, ams, apq, bld, cds, cmp, crp, exq, fmt, hfw, ola, pay, qdm, www

" To everybody, or empty
" bzr, com, sct

" Owners of each package
let g:AMA_CM_PKGS_OWNERS = {}
let g:AMA_CM_PKGS_OWNERS['acc'] = 'acc'
let g:AMA_CM_PKGS_OWNERS['bmt'] = 'bag'
let g:AMA_CM_PKGS_OWNERS['brd'] = 'dev'
let g:AMA_CM_PKGS_OWNERS['cfa'] = 'flt'
let g:AMA_CM_PKGS_OWNERS['cmt'] = 'cpr'
let g:AMA_CM_PKGS_OWNERS['cpr'] = 'cpr'
let g:AMA_CM_PKGS_OWNERS['cry'] = 'int'
let g:AMA_CM_PKGS_OWNERS['ctp'] = 'cpr'
let g:AMA_CM_PKGS_OWNERS['etk'] = 'acc'
let g:AMA_CM_PKGS_OWNERS['fli'] = 'flt'
let g:AMA_CM_PKGS_OWNERS['fmc'] = 'flt'
let g:AMA_CM_PKGS_OWNERS['hst'] = 'bag'
let g:AMA_CM_PKGS_OWNERS['idc'] = 'acc'
let g:AMA_CM_PKGS_OWNERS['inv'] = 'stg'
let g:AMA_CM_PKGS_OWNERS['lst'] = 'flt'
let g:AMA_CM_PKGS_OWNERS['onl'] = 'stg'
let g:AMA_CM_PKGS_OWNERS['pag'] = 'acc'
let g:AMA_CM_PKGS_OWNERS['prt'] = 'dev'
let g:AMA_CM_PKGS_OWNERS['reg'] = 'acc'
let g:AMA_CM_PKGS_OWNERS['rgd'] = 'stg'
let g:AMA_CM_PKGS_OWNERS['sec'] = 'flt'
let g:AMA_CM_PKGS_OWNERS['smt'] = 'stg'
let g:AMA_CM_PKGS_OWNERS['swp'] = 'cpr'
let g:AMA_CM_PKGS_OWNERS['syn'] = 'cpr'
let g:AMA_CM_PKGS_OWNERS['tci'] = 'acc'
let g:AMA_CM_PKGS_OWNERS['XXX'] = 'XXX'

" This String->StringList dictionary contains pkgs that have to be completed by the
" respective teams. The string "xxx" corresponds to package "ngxxx".
let g:AMA_CM_TEAM_PACKAGES = {}
let g:AMA_CM_TEAM_PACKAGES['acc'] = ['acc', 'cfa', 'cmt', 'ehb', 'etk', 'hub', 'idc', 'pag', 'reg', 'rri', 'tci', '???pub'] " Acceptance
let g:AMA_CM_TEAM_PACKAGES['stg'] = ['cmt', 'smt', 'rgd', 'inv', 'onl', "reg", 'tci', '???pub'] " Seating - OK
let g:AMA_CM_TEAM_PACKAGES['flt'] = ['flt', 'lst', 'sec', 'cfa'] " Flight
" TODO: ADD ALL THE TEAMS HERE !!

" }}}

" USEFUL MAPPINGS (Lowercase letter -> on current lineonly, uppercase -> all lines) {{{

" Reformat .gz logs when reading them directly with Vim
" I.e. replace ^_ and ^\ with  +, : and '
map \al :s//:/eg<bar>s//+/eg<bar>s//'\r/eg<cr>
map \aL :%s//:/g<bar>%s//+/eg<bar>%s//'\r/eg<cr>

" Split one-line edifact into several lines 
" Very useful in the logs
" (ie. add \n after quotes ('), but only if not escaped by ?)
map \ae :s/\w\w\w+[^']*?\@<!'/&\r/eg<cr>
map \aE :%s/\w\w\w+[^']*?\@<!'/&\r/eg<cr>

" :W and :W! does :w!
command! -bang W w!

" No more "F-F-F-Ffffuu :( " when you type :w1 instead of :w!
cabbr w1 :w!
cabbr q1 :q!

" }}}

"echomsg "Amadeus.vim general plugin loaded..."
