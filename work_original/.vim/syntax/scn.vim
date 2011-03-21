" Vim syntax file
" Language:         Regression scenario - SCN
" Maintainer:       Romain Chossart
" Last Change:      March 29, 2010
" Version:	    1.1

" Quit when a syntax file was already loaded	{{{
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
"}}}

" We could usr perl syntax but there is an issue w/ `` <<'EOD' `` statements
"runtime! syntax/perl.vim
"unlet b:current_syntax

""" SCENARIO ONLY --- Perl (light) {{{

syn region scnBlockBracketsReg matchgroup=scnBrackets start="{"hs=e end="}" contains=scnDictArrow keepend 

syn region scnBlockReg matchgroup=scnFunc start="^\w\+\_\s*{"rs=e-1 end="}\s*;"re=s+1 contains=scnBlockBracketsReg,scnBlockBracketsReg keepend
syn region scnBlockReg matchgroup=scnFunc start="^\w\+\_\s*(\_\s*{"rs=e-1 end="}\_\s*)\_\s*;"re=s+1 contains=scnBlockBracketsReg,scnBlockBracketsReg keepend

syn match scnDictArrow "=>" contained
syn match scnSpecial "\<\I\i*\s*=>"me=e-2

syn region scnString matchgroup=scnStringStartEnd start=+"+  end=+"+

syn match scnComment "#.*" contains=Todo

" Data (regression results)
syn region scnDataResultsReg matchgroup=scnDataResultsBounds start="__DATA__" end="" contains=scnDataResults



hi link scnFunc Function
hi link scnBrackets Special

hi link scnBlockReg Type
hi link scnBlockBracketsReg Type

hi link scnKeyword Keyword

hi link scnDictArrow Special

hi link scnString String
hi link scnStringStartEnd Statement
hi link scnComment Comment

hi link scnDataResultsBounds Special

" }}}



""" EDIFACT ONLY --- {{{

syn cluster edifOps contains=edifPlus,edifQuote,edifColon

" Keepend means "close as soon as possible"
syn region edifactQueryMsg start="^UNH+"ms=s end="^UNT+.*$"me=e contains=@edifOps keepend
syn region edifactResponseMsg start="^''UNH+"ms=s end="^''UNT+.*$"me=e contains=@edifOps keepend

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

""" SQL SNIPPETS --- {{{

syntax include @SQL syntax/sql.vim
syntax region sqlSnip start="^\c\(insert\|select\|update\|alter\|drop\|delete\)" skip="\\;" end=";"me=s-1 contains=@SQL keepend
"
"syntax region perlSnip matchgroup=Snip start="Database{" end="};" contains=@PERL keepend
"
hi link Snip SpecialComment


"}}}

