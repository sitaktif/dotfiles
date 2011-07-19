" Vim plugin to highlight surrounding brackets
" Last Change:  2011 Feb 09
" Maintainer:   Romain Chossart <romainchossart@gmail.com>
" License:	Feel free to use and modify this plugin in any way. Just
" mention previous authors.

"if exists("loaded_highlightcrackets")
"  finish
"endif
"let loaded_highlightcrackets = 1

if version < 702
    echo "This plugin requires vim 7.2"
    finish
endif

let s:matchid = 386519301
function! HLBR_update()
    "echomsg "Calling HLBR_update"
    let l:directions = [-1, 1] " Up and down

    for d in l:directions
        silent! call matchdelete(s:matchid+l:d)
        let l:cursor_char = strpart(getline('.'), col('.')-1, 1)
        if (l:cursor_char == '{' && l:d == -1) || (l:cursor_char == '}' && l:d == 1)
            " Cursor is on a '{' ; don't search backwards
            " or Cursor is on a '}' ; don't search forwards
            call matchadd('Error', '\%'.col('.').'c\%'.line('.').'l.', 10, s:matchid+l:d)
            continue
        endif

        let l:hard_counter = 100
        let l:bracket_counter = -l:d " Can be negative. { -> -- ; } -> ++


        "" First things first - process current line
        let l:ln = line('.')
        let l:lval = getline(l:ln)
        if l:d == -1
            let l:str = strpart(l:lval, 0, col('.') - 1)
        else
            let l:str = substitute(strpart(l:lval, 0, col('.')),"."," ","g")
            let l:str .= strpart(l:lval, col('.'))
        endif
        let l:retval = HLBR_scan(l:str, l:bracket_counter, l:d)
        if l:retval[0] == 0 " If counter has become equal to zero on the line
	    "echomsg "Add match at ".l:retval[1]."-".l:ln." - TOP"
            call matchadd('Error', '\%'.l:retval[1].'c\%'.l:ln.'l.', 10, s:matchid+l:d)
            continue
        else
            let l:bracket_counter = l:retval[0]
	    "echomsg l:bracket_counter
	    if l:retval[0] == 0 | finish| endif
        endif

        "" Then process in the right direction
        for l in range(l:hard_counter)
            let l:ln += l:d
            if l:ln < 0 || l:ln > line('$')
                let l:error = "One of the brackets have not been found"
                "echomsg l:error
                break
            endif
            let l:str = getline(l:ln)
            let l:retval = HLBR_scan(l:str, l:bracket_counter, l:d)
            if l:retval[0] == 0 " If counter has become equal to zero on the line
	    "echomsg "Add match at ".l:retval[1]."-".l:ln." - BOTTOM"
                call matchadd('Error', '\%'.l:retval[1].'c\%'.l:ln.'l.', 10, s:matchid+l:d)
                break
            else
                let l:bracket_counter = l:retval[0]
		"echomsg l:bracket_counter
		if l:retval[0] == 0 | finish| endif
            endif
        endfor

    endfor

    if exists('l:error')
        silent! call matchdelete(s:matchid+1)
        silent! call matchdelete(s:matchid-1)
    endif

endfunc

function! HLBR_scan(str, counter, dir)
    "echomsg " Direction: ".a:dir
    if a:counter == 0
        echohl Error|echomsg "HLBR_scan: counter arg cannot be 0"|echohl None
	return [42,42]
    endif

    let l:counter2 = a:counter
    let l:brak = {'{': -1, '}': 1}
    if a:dir == -1
        let l:col = len(a:str)
    elseif a:dir == 1
        let l:col = 1
    else
        echohl Error|echomsg "HLBR_scan: dir argument must be 1 or -1"|echohl None
    endif
    while l:col >= 1 && l:col <= len(a:str)
	let l:char = strpart(a:str, l:col-1, 1)
	let l:idx = index(keys(l:brak), l:char)
	" If we find a bracket
        if l:idx != -1
            let l:counter2 += l:brak[l:char]
            if l:counter2 == 0 | return [0, l:col] | endif
        endif
        let l:col += a:dir
    endwhile
    return [l:counter2, 0] " The 0 is useless..
endfunc

au CursorHold *.[hc]pp,*.i call HLBR_update()
