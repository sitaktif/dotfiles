
" Vim syntax file
" Language:         Amadeus Logs - Backend logs
" Maintainer:       Romain Chossart
" Last Change:      March 31, 2010
" Version:	    0.9

" Quit when a syntax file was already loaded	{{{
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    echomsg "Syntax already loaded"
    finish
endif
"}}}

" We could usr perl syntax but there is an issue w/ `` <<'EOD' `` statements
"runtime! syntax/perl.vim
"unlet b:current_syntax
"
"
"
"
"TST
"SYS
"DB
"TPM
"MDW
"SEC
"APP
"
"FATAL
"CRIT
"ERROR
"WARN
"NOT
"INFO
"LOG
"STAT
"TST
"DBG

syn region amalogAbstractLineReg start="^" end="$" oneline contains=amalogSectionLeft

syn match amalogSectionLeft "^\s*\(\S\+\s\+\)\{4}" contained contains=amalogDate nextgroup=amalogSectionMiddle
syn match amalogSectionMiddle "\u\{3,4}\s\+\u\{3,4}\s\+<[^>]*>\s\+\(\[PFX:[^]]\+\]\)\=" contained contains=amalogMidAppLayer nextgroup=amalogSectionRight
"syn match amalogSectionMiddle "\u\{3,4} \u\{3,4} <[^>]*> \(\[PFX:[^]]\]\)\=\s\+" contained contains=amalogMidAppLayer nextgroup=amalogSectionRight
syn match amalogSectionRight ".*$" contained contains=edifactQueryMsg,amalogKwError,amalogKwWarning


"" Left section

" Date, time, server, backend (actually I do not know what this is... whatever)
syn match amalogDate "\(\d\{4}/\d\{2}/\d\{2}\s\+\)\=" contained nextgroup=amalogTime " Can be omitted
syn match amalogTime "\d\{2}:\d\{2}:\d\{2}\.\d\{5}\s\+" contained nextgroup=amalogServer
syn match amalogServer "\U\+\d\+\s\+" contained nextgroup=amalogBackend
syn match amalogBackend "\w\+-\d\+\s\+" contained



""" Middle section

" Application layer
syn keyword amalogMidAppLayer SEC APP MDW contained nextgroup=@amalogMidLogLevel

" Log level
syn cluster amalogMidLogLevel contains=amalogMidLogLevelDbg,amalogMidLogLevelStat,amalogMidLogLevelTst,amalogMidLogLevelInfo,amalogMidLogLevelNot
syn keyword amalogMidLogDbg DBG contained
syn keyword amalogMidLogStat STAT contained
syn keyword amalogMidLogTst TST contained
syn keyword amalogMidLogInfo INFO contained
syn keyword amalogMidLogNotif NOT contained



"" File name and line number -- E.g. <EntAbstractHelper.cpp#36 TID#3>
syn match amalogTagsReg "<[^>]\{-}>" contained contains=amalogTagLeft
syn match amalogTagLeft "<" contained nextgroup=amalogFileName
syn match amalogFileName "\w\+\.\w\+" contained nextgroup=amalogFileSeparator
syn match amalogFileSeparator "#" contained nextgroup=amalogFileLineNr
syn match amalogFileLineNr "\d\+ " contained nextgroup=amalogTagRemaining
syn match amalogTagRemaining "\w\+#\d\+" contained nextgroup=amalogTagRight
syn match amalogTagRight ">" contained


"" Keywords
syn keyword amalogKwError Error error contained
syn match amalogKwError "\cerror" contained
syn match amalogKwException "\cexception" contained

hi link amalogSectionLeft Comment
hi link amalogSectionMiddle Identifier


" Regions
hi amalogDbgReg ctermbg=none ctermfg=lightred
hi amalogStatReg ctermbg=none ctermfg=lightgreen
hi amalogTstReg ctermbg=none ctermfg=lightyellow
hi amalogInfoReg ctermbg=none ctermfg=lightblue

" Header - Date, time, server
hi link amalogDate Comment
hi link amalogTime Comment
hi link amalogServer Comment
hi link amalogBackend Comment


" Tag - < File # Number  # Remaining >
hi link amalogTagLeft StorageClass
hi link amalogFileName none
hi link amalogFileSeparator StorageClass
hi link amalogFileLineNr none
hi link amalogTagRemaining none
hi link amalogTagRight StorageClass

" Special Keywords
hi link amalogKwError ErrorMsg
hi link amalogKwException WarningMsg

""" EDIFACT ONLY --- {{{

syn cluster edifOps contains=edifPlus,edifQuote,edifColon

" Keepend means "close as soon as possible"
syn region edifactQueryMsg start="^UNH+"ms=s end="^UNT+.*$"me=e contains=@edifOps keepend
syn region edifactResponseMsg start="^''UNH+"ms=s end="^''UNT+.*$"me=e contains=@edifOps keepend
syn region edifactQueryMsg start="^UN[AB]+"ms=s end="^UNZ+.*$"me=e contains=@edifOps keepend
syn region edifactResponseMsg start="^''UN[AB]+"ms=s end="^''UNZ+.*$"me=e contains=@edifOps keepend

"syn keyword edifPlus contained +
"syn keyword edifQuote contained '

syn match edifPlus contained "+"
syn match edifQuote contained "'"
syn match edifColon contained ":"


hi link edifPlus PreProc
hi link edifColon Delimiter
hi link edifQuote Character

hi link edifactQueryMsg	String
hi link edifactResponseMsg Comment
"}}}
 
