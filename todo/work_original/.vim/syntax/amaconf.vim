
" Vim syntax file
" Language:         Amadeus Conf - EDI/CPP mappings
" Maintainer:       Romain Chossart
" Last Change:      July 14, 2010
" Version:	    0.9

" Quit when a syntax file was already loaded	{{{
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
"}}}


"" Global syntax {{{
"
syn match amaconfComment "#.*"
syn cluster amaconfOperator contains=amaconfOperatorEqual,amaconfOperatorComma
syn match amaconfOperatorEqual "="
syn match amaconfOperatorComma ","
syn match amaconfOperatorDot "\."

syn match amaconfInclude "include"
syn keyword amaconfNamespace namespace 

" Options are in amaconfMsg [x], amaconfCmp [ ], amaconfGrp [ ]
syn match amaconfOption "\(\w\|_\|=\)\+\s*" contained nextgroup=amaconfOptionComma contains=amaconfOptionLeft
    syn match amaconfOptionLeft "\(\w\|_\)\+\s*" contained nextgroup=amaconfOptionEqual
    syn match amaconfOptionEqual "=" contained nextgroup=amaconfOptionRight
    syn match amaconfOptionRight "\(\w\|_\)\+\s*" contained 
syn match amaconfOptionComma ",\s*" contained nextgroup=amaconfOption

"
"" End of global syntax }}}


"" Line ``define'' {{{
"
syn match amaconfDefineReg "\<define\>.*$" contains=amaconfDefine,amaconfComment
syn match amaconfDefine "\<define\>\s\+" nextgroup=amaconfMsg,amaconfClass,amaconfGrp contained 

syn match amaconfMsg "Msg\s\+" contained nextgroup=amaconfMsgName
syn match amaconfMsgName "\(\w\|_\)\+\s\+" contained nextgroup=amaconfOption

syn match amaconfGrp "Grp\s\+" contained nextgroup=amaconfGrpName
syn match amaconfGrpName "\(\w\|_\)\+\s*" contained nextgroup=amaconfOption

" For svi.conf files
syn match amaconfClass "Class\s\+" contained

"
"" End line ``define'' }}}

"" Line ``Seg'' and ``Grp'' {{{
"
syn region amaconfSegReg start="^\s*\(\<Seg\>\|\<Grp\>\)" end="$" contains=amaconfSeg,amaconfComment
syn match amaconfSeg "\(\<Seg\>\|\<Grp\>\)\s\+" nextgroup=amaconfSegType contained
syn match amaconfSegType "\(\w\|_\|\.\)\+\s\+" nextgroup=amaconfSegName contained
syn match amaconfSegName "\(\w\|_\)\+\s*" nextgroup=amaconfOption contained
"
"" End line ``Seg'' and ``Grp'' }}}
"
"" Line ``Cmp'' {{{
"
syn region amaconfCmpReg start="^\s*\<Cmp\>" end="$" contains=amaconfCmp,amaconfComment
syn match amaconfCmp "\<Cmp\>\s\+" nextgroup=amaconfCmpType contained
syn match amaconfCmpType "\(\w\|_\|\.\)\+\s\+" nextgroup=amaconfCmpName contained
syn match amaconfCmpName "\(\w\|_\)\+\s*" nextgroup=amaconfOption contained
"
"" End line ``Cmp'' }}}


"" Line ``Tag'' {{{
"
syn region amaconfTagReg start="^\s*\<Tag\>" end="$" contains=amaconfTag,amaconfComment
syn match amaconfTag "\<Tag\>\s\+" nextgroup=amaconfTagType contained
syn match amaconfTagType "\(\w\|\*\)\+\s\+" nextgroup=amaconfTagName contained
syn match amaconfTagName "\(\w\|_\|\.\)\+\s*" contained nextgroup=amaconfOption
"
"" End line ``Tag'' }}}

"" Line ``Data'' {{{
"
syn region amaconfDataReg start="^\s*\<Data\>" end="$" contains=amaconfData,amaconfComment
syn match amaconfData "\<Data\>\s\+" nextgroup=amaconfDataName contained
syn match amaconfDataName "\(\w\|_\)\+\s*" contained nextgroup=amaconfOption
"
"" End line ``Data'' }}}

"" Some remaining stuff
syn keyword amaconfMacro defmacro usemacro
syn keyword amaconfMap Map
syn keyword amaconfPair Pair

"" Global links

hi link amaconfComment Comment
hi link amaconfOperatorEqual Operator
hi link amaconfOperatorComma Operator
hi link amaconfOperatorDot Operator

hi link amaconfOptionLeft Type
hi link amaconfOptionEqual Operator
hi link amaconfOptioncomma Operator

hi link amaconfMacro Statement

"" Define (Msg and Grp)
hi link amaconfMsg Define
hi link amaconfMsgName Identifier
hi link amaconfGrp Define
hi link amaconfGrpName Statement

"" Seg and Grp
hi link amaconfSeg Structure
hi link amaconfSegType Number
hi link amaconfSegName Identifier

"" Cmp
hi link amaconfCmp Define
hi link amaconfCmpType Number
hi link amaconfCmpName Identifier

hi link amaconfTag Define
hi link amaconfTagType Number
hi link amaconfTagName Identifier

hi link amaconfData Statement
hi link amaconfDataName Identifier

" Remaining stuff
hi link amaconfMap Statement
hi link amaconfPair Statement

" svi.conf
hi link amaconfInclude Include
hi link amaconfNamespace Statement

hi link amaconfDefine Typedef
hi link amaconfClass Define
