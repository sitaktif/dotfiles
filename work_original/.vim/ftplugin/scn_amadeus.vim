" Vim regression scenarii plugin for Amadeus
" Last Change:	2011 Feb 04
" Maintainer:	Romain Chossart <romainchossart@gmail.com>
" License:	This plugin is the property of Amadeus Services Ltd.

" Note: Use "za" keystrokes to alternate folding below.
"
"
" This plugin takes care of the tag configuration for scn cases.
" It enables:
"  - Jump to tag with <c-]>
"  - Completion of functions with <c-x><c-]>

echomsg "Loading scn_amadeus.vim..."

function! SCNMakePerlTags()
    let l:path = expand('%:p:h')
    let l:pwetop = matchstr(l:path, '\zs.\{-}\ze/ng...rgr/')
    let l:package = matchstr(l:path, '/ng\zs\(...\)\zergr/')
    if l:package == ""
	echohl ErrorMsg
	echomsg "FATAL: Cannot determine current NGD package."
	echohl None
	return
    endif

    " ."_".fnamemodify(l:pwetop, ":t")
    let l:tagfile = "/tmp/scn_tags_".expand("$USER")
    let l:ftime = getftime(l:tagfile)
    let l:timespan = localtime() - l:ftime

    if str2nr(l:timespan) > (3600 * 12)
	echomsg "Tags have not been updated for 12h, updating..."
	exec "!ctags -R -f ".l:tagfile." --regex-perl='/^[ \\t]*name[ \\t]*=>[ \\t]*[\"'\\'']([a-zA-Z0-9_]+)[\"'\\'']/\\1/d,definition/' ".l:pwetop."/ngcomrgr/lib/dev/???"
    "exec "!echo ".l:pwetop."/ngcomrgr/lib/dev/???"
	echomsg "Tags have been updated."
    endif

    if  !(filereadable(l:tagfile))
	echohl ErrorMsg
	echomsg "File ".l:tagfile." is not readable. Skipping."
	echohl None
	return
    endif
    if stridx(&tags, l:tagfile) == -1
	exec 'set tags+='.l:tagfile
    endif
endfunc


setlocal omnifunc=syntaxcomplete#Complete

call SCNMakePerlTags()

map <buffer> <f12> :call SCNMakePerlTags()<cr>


""
" Useful options
""
set sw=4
set ts=4
set sts=4
set expandtab


""
" Useful abbrevs
""

" Tables
iabbr DBBFP T_CM_BOOKED_FLIGHT_PRODUCT
iabbr DBCLD T_CM_CUSTOMER_LEG_DELIVERY
iabbr DBCUST T_CM_CUSTOMER
iabbr DBFLD T_CM_OPERATING_FLIGHT_LEG_DATE

" Attributes
iabbr DBOFN OPERATING_FLIGHT_NUMBER
iabbr DBOCC OPERATING_T_RF_CARRIER_CODE
iabbr DBMFN MARKETING_FLIGHT_NUMBER
iabbr DBMCC MARKETING_T_RF_CARRIER_CODE

