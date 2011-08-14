"==============================
"========== SmartTag ==========
"======= by Robert Webb =======
"== http://www.software3d.com =
"== Stella4D AT gmail DOT com =
"==============================
"
" License: This file is placed in the public domain.
" But please let me know if you modify it, and please keep the reference above
" to me as the author if redistributing.
"
" Use context to tag more sensibly:
" - Try to resolve ambiguous tags
" - Tag to overloaded operators
" - Tag with cursor on "delete" to jump to destructor
" - Tag to local variables (not defined in tags file)
"
"==================
"=== How to use ===
"==================
"
" Put this file in $VIMRUNTIME/plugin
"
" To use SmartTag all the time, in place of vim's own tag mechanism, you'll
" need a version of vim with Lech Lorens's 'tagfunc' patch.  You can get it
" here:
" http://repo.or.cz/w/vim_extended.git/shortlog/refs/heads/feat/tagfunc
"
" Then put this in your .vimrc or _vimrc file:
"	set tagfunc=SmartTagFunc
"
" You may now also do the following to specify the class for a tag:
"	:tag ClassB::mNext
" 
" Otherwise, if you just want to use SmartTag via mappings, separate from vim's
" normal tagging, set up some mappings in your .vimrc or _vimrc file, eg:
"	nmap <C-_><C-_>   :call SmartTag("goto")<CR>
"	nmap <C-_><C-W>   :call SmartTag("split")<CR>
"	nmap <C-_><C-T>   :call SmartTag("tab")<CR>
"	nmap <C-_><C-D>   :call SmartTag("debug")<CR>
" That last one is only needed for debugging this script.
"
" The above mappings explained:
"	Ctrl-_ Ctrl-_   -   Jump to tag under cursor
"	Ctrl-_ Ctrl-W   -   Split to tag under cursor
"	Ctrl-_ Ctrl-T   -   Create new tab for tag under cursor
"	Ctrl-_ Ctrl-D   -   Show debug info about finding tag under cursor
"
" There's also a function that attempts to determine the type of whatever's
" under the cursor, but it doesn't always work very well, and will mostly only
" find the basic type, not whether it's a pointer to that type or an array etc.
" If you want to try it, use a mapping like this:
"	map _t	:call ShowType()<CR>
"
" Note: unless you use 'tagfunc', you can't use Ctrl-T to jump back to where
" you tagged from.  Nor can you use :tn etc to try the next tag if it guesses
" wrong.
"
" === Requirements ===
"
" Use the "--fields=+iS" flags with ctags when generating your tags.
" See Exuberant Ctags (other ctags may not have those options).
"
" Without the "+i" field, SmartTag will not know which classes inherit from
" other classes.
"
" Without the "+S" field, SmartTag will mostly work fine, but there may be
" more cases where it can't tell which overloaded function to use within a
" class.  It can't count the number of args to a function as easily, but it
" does still try, so most of the time it may not make a difference.  Using "+S"
" does increase the size of your tags file too, so you may leave this flag out
" if you wish.
"
"================
"=== Examples ===
"================
"
" Examples (with cursor on "bar"):
"   ~bar	Tag to destructor
"   foo::bar	Tag to bar as defined in class foo only
"   ::bar	Tag to bar in global namespace only
"
"   Type foo
"   ...
"   foo.bar	Tag to bar as defined in class Type
"
"   Type *foo
"   ...
"   foo->bar	Tag to bar as defined in class Type
"
"   class Type : public Base
"   ...
"   Type *foo
"   ...
"   foo->bar	Tag to bar as defined in class Type, or failing that, in Base
"
"   Type::foo()
"   {...
"   bar		Tag to bar as defined in class Type, and failing that try bar
"		in the global namespace
"
"   bar(1)	Tag to function bar() which takes a single argument
"   bar(1, 2)	Tag to function bar() which takes two arguments
"
" If you put the cursor on an operator (eg +, ++, -> etc), it will first check
" to see if there's a function overriding the operator.  It distinguishes
" between unary and binary operators, and between pre and post increment.
" If no tag is found for the operator, it looks at the identifier after the
" operator as usual.
"
" It will also take you to definitions of local variables which have no tag,
" and take you from goto statements to their matching labels.
"
"====================
"=== Known issues ===
"====================
"
" Some cases are not recognised:
"
" - See TODO in the test files for some examples.
"
" - Multiple functions with the same name within a single class are
"   distinguished only by the number of arguments they take, not by the type of
"   those args.
"
" - We have no way of handling virtual functions, ie of jumping to the
"   appropriate version in a derived class.  This is decided at runtime and the
"   same line of code may jump to different virtual functions at different
"   times.  It would be nice at least to know which tags are plausible however.
"
" Changes required to vim to fix some problems:
"	See my posts for unresolved issues:
"	http://tech.groups.yahoo.com/group/vimdev/message/51652 (script begins)
"	http://tech.groups.yahoo.com/group/vimdev/message/51680	('tagfunc')
"	http://tech.groups.yahoo.com/group/vimdev/message/51805 (split bug)
"	http://tech.groups.yahoo.com/group/vimdev/message/51889 (repeated tags)
"
" - Ability to perform two searches one after the other in a tag command.
"   Eg "/class Blah//int var" would find Blah::var but not other occurrences of
"   "int var" defined earlier in the file.  My script currently does the
"   searching itself, so this isn't a problem, but it will be if 'tagfunc' is
"   made available in the future.  Then my script would just return the tag
"   matches whose search commands must be self-contained, ready for vim to
"   execute.
"
" - taglist() should escape characters as necessary in the ex commands, so that
"   they may be executed without further massaging (obviously this already
"   happens internally somewhere).  Can use "escape(tagCmd, '*[]~')".  Any
"   other characters?  Note: ctags already escapes / and \
"
" - taglist() returns all tags found in all tag files, whereas jumping to a tag
"   doesn't generally require looking at all tag files if a match is found in
"   the first one.  Maybe taglist() could take an optional argument with the
"   index of the tag file to use.  This might be handy in conjunction with
"   'tagfunc'.  The user's tag function would then probably also need the extra
"   arg so it knows to restrict its search.
"
" - Fix the bug detailed here:
"   http://tech.groups.yahoo.com/group/vimdev/message/51805
"
"====================
"=== How it works ===
"====================
"
" If the tag under the cursor is ambiguous, look back before identifier for
" ., -> or ::.  If found, try to establish the type of the preceding
" identifier.  This narrows the possible tags for our original identifier.
" It we still have more than one possibility, then search back further.
"
" If ::, preceding identifier gives us the class.
" If . or ->, may need to recursively go back past successive . or ->
" If none of the above found, it may be a member of the class of the current
" function.  Failing that, look for a local or global var, or tag normally.
"
" -------------------
" --- More detail ---
" -------------------
"
" Example: Cursor on "a" below.
"   C++ code:	d ->		preId ->	id ->		a
"   level:	3		2		1		0
"   Types:	Cd1::Td1	Cc1::Tc1	Cb1::Ca1	Ca1::Ta1
"   Types:	Cd2::Cc3	Cc2::Cb1	Cb1::Ca2	Ca2::Ta2
"   Types:	Cd3::Cc4	Cc3::Tc2	Cb2::Tb1	Ca3::Ta3
"   Types:	Cd4::Td2	Cc4::Cb3	Cb3::Ca5	Ca4::Ta4
"   Types:					Cb4::Ca6	Ca5::Ta5
"   Types:							Ca6::Ta6
"   Types:							Ca7::Ta7
"
" We build up a list of possible types for "a".  If there's more than one, then
" we look back past the "->" to "id" and find its possible types.  This may
" eliminate some of the possible types for "a".  If we still have more than one
" possible type, then we continue looking back.
"
" At level 0:
" [0] Ca1::Ta1 Ca2::Ta2 Ca3::Ta3 Ca4::Ta4 Ca5::Ta5 Ca6::Ta6 Ca7::Ta7
"
" At level 1:
" Remove [1] Tb1 which doesn't appear in [0]
" Remove [0] Ca3,Ca4,Ca7 which don't appear in [1]
" [0] Ca1::Ta1 Ca2::Ta2 Ca5::Ta5 Ca6::Ta6
" [1] Cb1::Ca1 Cb1::Ca2 Cb3::Ca5 Cb4::Ca6
"
" At level 2:
" Remove [2] Tc1,Tc2 which don't appear in [1]
" Remove [1] Cb4 which doesn't appear in [2]
" Remove [0] Ca6 which doesn't appear in [1]
" [0] Ca1::Ta1 Ca1::Ta2 Ca2::Ta5
" [1] Cb1::Ca1 Cb1::Ca2 Cb3::Ca1
" [2] Cc1::Cb1 Cc4::Cb3
"
" At level 3:
" Remove [3] Td1,Td2,Cc3 which don't appear in [2]
" Remove [2] Cc1 which doesn't appear in [3]
" Remove [1] Cb1 which doesn't appear in [2]
" Remove [0] Ca2 which doesn't appear in [1]
" [0] Ca1::Ta1 Ca1::Ta2
" [1] Cb3::Ca1
" [2] Cc4::Cb3
" [3] Cd3::Cc4
"
" If any level has only one possible type then we can stop looking, even if
" level 0 still has more than one (further looking won't be able to resolve
" it).
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:oldCpo = &cpo
set cpo&vim

"================ GENERAL UTILS ===================

func! Error(message)
    echohl ErrorMsg
    echo a:message
    echohl None
endfunc

func! CursorChar()
    return getline(".")[col(".") - 1]
endfunc

" Compare cursor positions obtained using getpos(".")
func! CursorCmp(pos1, pos2)
    if (a:pos1[1] > a:pos2[1])
	return 1
    elseif (a:pos1[1] < a:pos2[1])
	return -1
    elseif (a:pos1[2] > a:pos2[2])
	return 1
    elseif (a:pos1[2] < a:pos2[2])
	return -1
    endif
    return 0
endfunc

func! StartOfWord()
    call search('.\>', 'cWs')
    call search('\<', 'cWb')
endfunc

" Go to next non-whitespace character in the file, skipping comments.
" Arg 1 is the search pattern, default is '\S' to only skip space.
" Arg 2 is a string of flags as follows:
"   'c': search includes the cursor.
"   '#': skip lines starting with #.
" Return the line number containing the match, or 0 upon failure.
func! StepForwardNonComment(...)
    let pattern = '^\S'
    let flags = 'W'
    let skipHash = 0
    if (a:0 >= 1)
	let pattern = '^' . a:1
    endif
    if (a:0 >= 2 && a:2 =~ 'c')
	let flags = 'c' . flags
    endif
    if (a:0 >= 2 && a:2 =~ '#')
	let skipHash = 1
    endif
    while (1)
	" TODO: Could be more efficient.  Get line and search within that.
	let oldLNum = line(".")
	if (!search('.', flags))
	    return 0
	endif
	if (flags[0] == 'c')
	    let flags = strpart(flags, 1)
	endif
	let lnum = line(".")
	let line = getline(".")
	let col = col(".") - 1
	if (lnum > oldLNum && skipHash)
	    " Skip lines starting with #
	    if (match(line, '^\s*#') >= 0)
		normal $
		continue
	    endif
	endif
	if (line[col] == '/')
	    " If it's a comment, skip it.
	    if (line[col + 1] == '/')
		normal $
		continue
	    elseif (line[col + 1] == '*')
		normal %
		if (lnum == line(".") && col == col(".") - 1)
		    return 0	" "/*" has no matching "*/"
		endif
		" matchit script leaves cursor on "*" rather than "/"
		if (CursorChar() == '*')
		    normal l
		endif
		continue
	    endif
	endif
	if (match(line, pattern, col) >= 0)
	    break
	endif
    endwhile
    return line(".")
endfunc

" Go to previous non-whitespace character in the file, skipping comments.
" Arg 1 is the search pattern, default is '\S' to only skip space.
" Arg 2 is a string of flags as follows:
"   'c': search includes the cursor.
"   '#': skip lines starting with #.
" Return the line number containing the match, or 0 upon failure.
func! StepBackNonComment(...)
    let pattern = '^\S'
    let flags = 'bW'
    let skipHash = 0
    if (a:0 >= 1)
	let pattern = '^' . a:1
    endif
    if (a:0 >= 2 && a:2 =~ 'c')
	let flags = 'c' . flags
    endif
    if (a:0 >= 2 && a:2 =~ '#')
	let skipHash = 1
    endif
    while (1)
	" TODO: Could be more efficient.  Get line and search within that.
	let oldLNum = line(".")
	if (!search('.', flags))
	    return 0
	endif
	if (flags[0] == 'c')
	    let flags = strpart(flags, 1)
	endif
	let lnum = line(".")
	let line = getline(".")
	let col = col(".") - 1
	if (lnum < oldLNum)
	    " Skip lines starting with #
	    if (skipHash)
		let i = matchend(line, '^\s*#') - 1
		if (i >= 0 && i < col)
		    normal 0
		    if (i > 0)
			exec 'normal ' . i . 'l'
		    endif
		    continue
		endif
	    endif
	    " If we enter a single-line comment, go to where it starts and
	    " continue search backwards from there.
	    let i = match(line, '//')
	    if (i >= 0 && i < col)
		normal 0
		if (i > 0)
		    exec 'normal ' . i . 'l'
		endif
		continue
	    endif
	endif
	if (line[col] == '/' && col > 0 && line[col - 1] == '*')
	    " Skip back over C-style comment.
	    normal %
	    if (lnum != line(".") || col != col(".") - 1)
		continue
	    endif
	endif
	if (match(line, pattern, col) >= 0)
	    break
	endif
    endwhile
    return line(".")
endfunc

" Call this with the cursor possibly on a ">" to skip back over any <..>
" template stuff.  Cursor will end up on the first character before <..>.
" If ">" is not under cursor, cursor will not move.
" This function presumes "<:>" is present in &matchpairs.  Caller should first
" use :set matchpairs+=<:>
func! SkipBackOverTemplate()
    let c = CursorChar()
    while (c == ">")
	silent! normal %
	if (CursorChar() != "<")
	    break
	endif
	call StepBackNonComment()
	let c = CursorChar()
    endwhile
endfunc

func! SameFiles(file1, file2)
    return (fnamemodify(resolve(expand(a:file1)), ':p') ==
	    \ fnamemodify(resolve(expand(a:file2)), ':p'))
endfunc

" Grab text between the given cursor positions (as returned by getpos(".")) and
" return as a single string, lines being appended together.
func! GetText(startPos, endPos)
    let lnum = a:startPos[1]
    let line = getline(lnum)
    if (a:endPos[1] == lnum)
	" Special case, start and end on same line.
	return strpart(line, a:startPos[2] - 1, a:endPos[2] - a:startPos[2] + 1)
    endif
    let text = strpart(line, a:startPos[2] - 1)
    let lnum += 1
    while (lnum <= a:endPos[1])
	let line = getline(lnum)
	if (lnum == a:endPos[1])
	    let line = strpart(line, 0, a:endPos[2])
	endif
	let text .= line
	let lnum += 1
    endwhile
    return text
endfunc

"================ SMARTTAGS FUNCTIONS ===================

let s:PreTypeSkip = '\<\(const\|static\|struct\|class\|virtual\|inline\|' .
			\ 'register\|volatile\|auto\)\>'
let s:PreTypeInclude = '\<\(typedef\|enum\|union\)\>'

" Return the function's class name and leave the cursor on the start of the
" member following it.  Presumes the form "Class::Member".  Cursor must be on
" the opening "(" of the function header.
func! GetFuncClassName()
    let str = getline(".")
    let pos = match(str, '::')
    let col = col(".") - 1
    if (pos < 0 || pos >= col)
	normal 0%%b
	return ''
    endif
    let firstPos = pos
    let nextPos = match(str, '::', pos + 1)
    while (nextPos > pos && nextPos < col)
	let pos = nextPos
	let nextPos = match(str, '::', pos + 1)
    endwhile
    normal 0
    if (pos > 0)
	exec 'normal ' . firstPos . 'l'
    endif
    normal B
    call search('\h', 'cW')
    let start = col(".") - 1
    normal 0
    if (pos >= 0)
	exec 'normal ' . (pos + 1) . 'l'
    endif
    call StepForwardNonComment()
    return strpart(str, start, pos - start)
endfunc

" Return the name of the class for the function containing the cursor.
" Set the global g:IsInFunctionBody to 1 if we appear to be in a function body,
" that is, between the {}.
func! GetThisClass()
    let oldWin = winsaveview()
    let class = ""
    let fullClass = ""
    let g:IsInFunctionBody = 1

    " There are two simple ways to find the start of a function:
    " 99999[{ - Fails if there are open braces within comments (goes too far).
    " [[ - Fails if a "{" within the function appears in the first column.
    "		Also fails if a function's "{" is not in the first column.
    "		Also fails if we're currently not within a {..} block.
    " These are all things I've seen in real code.
    " Instead we use "[{" and repeat till it seems we've found the right place.
    let firstTime = 1
    while (1)
	let origCursor = getpos(".")
	silent! normal [{
	let oldCursor = getpos(".")
	if (!firstTime && oldCursor == origCursor)
	    break	" We're stuck at start of outer {..} block.
	endif
	let firstTime = 0
	if (CursorChar() != '{')
	    " We weren't inside a function nor a class declaration.  Maybe
	    " we're in a function header though.  Look for a closing ")", but
	    " not if we hit something not expected in a function header first.
	    let g:IsInFunctionBody = 0
	    let badPos = [0, 0, 0, 0]
	    if (StepForwardNonComment('[{};]', '#') != 0)
		let badPos = getpos(".")
	    endif
	    call setpos('.', oldCursor)
	    normal 99999])
	    let newPos = getpos(".")
	    if (CursorCmp(newPos, oldCursor) == 0)
		" Cursor didn't move, so we're not inside (..)
		" Search forward for an opening "(" first, but don't pass
		" anything we're not expecting.
		call setpos('.', oldCursor)
		if (StepForwardNonComment('(', '#') != 0)
		    normal %
		    let newPos = getpos(".")
		    if (CursorCmp(newPos, oldCursor) == 0 ||
			\ CursorCmp(newPos, badPos) > 0)
			call setpos('.', oldCursor)	    " Go back
		    endif
		endif
	    elseif (CursorCmp(oldCursor, badPos) > 0)
		" We were inside (..), but we hit something unexpected along
		" the way, so abort this idea.
		call setpos('.', oldCursor)	    " Go back
	    endif
	    "let newPos = getpos(".")
	    "if (CursorCmp(newPos, oldCursor) == 0)
		" We don't appear to be in a function heading, maybe we're in a
		" class declaration header.
	    "endif
	elseif (StepBackNonComment('[)};]', '#') != 0)
	    let g:IsInFunctionBody = 1
	else
	    1
	endif
	if (CursorChar() == ')')
	    normal %
	    let class = GetFuncClassName()
	else
	    " Not in a function body, but maybe in a class/struct definition.
	    let g:IsInFunctionBody = 0
	    let limit = getpos(".")
	    call setpos('.', oldCursor)
	    if (search('\<\(class\|struct\|union\)\>', 'beW') > 0)
		let cursor = getpos(".")
		if (CursorCmp(cursor, limit) >= 0)
		    call StepForwardNonComment() " Skip space after "class" etc
		    if (CursorChar() =~ '\w')
			let class = expand("<cword>")
		    endif
		endif
	    endif
	endif
	if (class != "")
	    " We could just break here and return 'class' at the end, but we
	    " would miss out on nested classes/structs.  So keep going and
	    " build up what may be a nested class.  On the down side, this may
	    " be inefficient in large files, and may find false nestings if
	    " there's some strange code earlier on, like maybe an open { inside
	    " a comment?
	    "break
	    if (fullClass == "")
		let fullClass = class
	    else
		let fullClass = class . "::" . fullClass
	    endif
	endif
	call setpos('.', oldCursor)
    endwhile
    call winrestview(oldWin)
    return fullClass
endfunc

" Find the type of the variable declared under the cursor.
" Cursor should be on first character of identifier.
" Return "" if this does not appear to be a declaration.
func! FindDeclarationType()
    let oldPos = getpos(".")
    " Check character before our variable.  Should be a comma, or an identifier
    " (the type).
    call StepBackNonComment('[^ 	*]', '#')
    let c = CursorChar()
    if (c == '&') " Only allow one of these.  Want type &var, not a && b.
	call StepBackNonComment('[^ 	*]', '#')
	let c = CursorChar()
    endif
    if (c == '>')
	normal %
	let c = CursorChar()
	if (c == '<')
	    call StepBackNonComment('\S', '#')
	    let c = CursorChar()
	endif
    endif
    if (c !~ '[a-zA-Z_0-9,]')
	return ""
    endif
    let type = expand("<cword>")
    if (type == "return" || type == "new" || type == "delete" ||
	\ type == "else" || type == "goto")
	return ""
    endif
    call setpos('.', oldPos)

    " Check we're not in a function call, ie not inside (..)
    silent! normal [(
    let line = getline(".")
    let col = col(".") - 1
    let bracketLine = -1
    let bracketCol = -1
    let commaLine = -1
    let commaCol = -1
    let isInBrackets = 0
    if (line[col] == '(')
	" We might be in a function argument list, not what we wanted.
	" But we might also have found an unclosed "(" in a comment, so we
	" check for that later.
	let bracketLine = line(".")
	let bracketCol = col
	call setpos('.', oldPos)
    endif
    while (1)
	let lineNum = StepBackNonComment('[(,>{};]', '#')
	if (lineNum <= 0)
	    break
	endif
	let c = CursorChar()
	if (c == '>')
	    normal %
	elseif (c == ',')
	    " Remember first comma we pass.
	    if (commaLine < 0)
		let commaLine = lineNum
		let commaCol = col(".") - 1
	    endif
	elseif (c == '(')
	    if (bracketCol == col(".") - 1 && bracketLine == lineNum)
		" We really are inside (..).  Bad unless we're in the list of
		" args for the function currently being defined.  In that case
		" we only want to search back to the opening "(" or a comma.
		let isInBrackets = 1
		if (commaLine > 0)
		    exec commaLine
		    normal 0
		    if (commaCol > 0)
			exec 'normal ' . commaCol . 'l'
		    endif
		endif
		break
	    endif
	else " One of {};
	    break
	endif
    endwhile
    if (lineNum > 0)
	call StepForwardNonComment('\S', '#')
    endif

    " Hopefully the type is now under the cursor.  Skip things like const
    " though.
    while (1)
	let type = expand("<cword>")
	if (match(type, '^' . s:PreTypeSkip . '$') < 0 &&
	    \ match(type, '^' . s:PreTypeInclude . '$') < 0)
	    break
	endif
	normal e
	call StepForwardNonComment('\S', '#')
    endwhile

    " Avoid thinking things like "return" are types.
    if (type == "return" || type == "new" || type == "delete" ||
	\ type == "else" || type == "goto")
	return ""
    endif
    if (match(CursorChar(), '\h') < 0)
	" Expected an identifier
	return ""
    endif

    let type = TrueClassName(type)
    while (1)
	normal e
	call StepForwardNonComment('\S', '#')
	let line = getline(".")
	let col = col(".") - 1
	if (line[col] == '<')
	    normal %
	    call StepForwardNonComment('\S', '#')
	    let line = getline(".")
	    let col = col(".") - 1
	endif
	if (line[(col):col+1] != "::")
	    break
	endif
	normal l
	call StepForwardNonComment('\S', '#')
	if (match(CursorChar(), '\h') < 0)
	    break	" Expected an identifier
	endif
	let type .= "::" . TrueClassName(expand("<cword>"))
    endwhile
    call StepBackNonComment('\S', '#')
    let newPos = getpos(".")
    if (CursorCmp(newPos, oldPos) > 0)
	" Type should have been before where cursor started.
	return ""
    endif

    " Finally, a declaration should have a ";" after it before a "{", unless it
    " was in the argument list for the function.  Otherwise, we probably found
    " the name of the function itself rather than a variable declaration.
    if (!isInBrackets)
	call setpos('.', oldPos)
	call StepForwardNonComment('[;{]', '#')
	if (CursorChar() != ';')
	    return ""
	endif
	call setpos('.', newPos)
    endif

    return type
endfunc

" Strip <..>, (..) and [..] from the given type name and return the result.
func! StripTemplateEtc(type)
    let newType = a:type
    let prevType = ""
    while (newType != prevType)
	let prevType = newType
	let newType = substitute(prevType,
	    \ '<[^<>]*>\|([^()]*)\|\[[^][]*\]', '', 'g')
    endwhile
    let newType = substitute(newType, '[*&]', '', 'g')
    let newType = substitute(newType, '^\s\+', '', '')
    return substitute(newType, '\s\+$', '', '')
endfunc

" Remove duplicate entries from the given list.  This is required because vim
" should do it but doesn't.  We're not talking about tags of the same name,
" which may represent multiple occurrences, but tags of the same name from the
" same file AND located the same way.  This can happen when the tags come from
" different tag files, eg "tags" and "../tags".  If the latter includes tags
" from all subfolders, then it will repeat tags from the former.
func! UniqList(list)
    let i = len(a:list) - 1
    while (i > 0)
	let j = 0
	while (j < i)
	    if (a:list[j] == a:list[i])
		call remove(a:list, i)
		break
	    endif
	    let j += 1
	endwhile
	let i -= 1
    endwhile
endfunc

" Return a tag list with no repeated entries.
func! UniqTagList(name, splitClass)
    let i = -1
    if (a:splitClass)
	let i = strridx(a:name, '::')
    endif
    if (i < 0)
	" No "::" so don't worry about what class we belong to.
	let tags = taglist('^' . a:name . '$')
    else
	" Found "::".  Separate the class and tag name.
	let name = strpart(a:name, i + 2)
	let class = strpart(a:name, 0, i)
	let tags = taglist('^' . name . '$')
	let i = 0
	while (exists("tags[i]"))
	    let tag = tags[i]
	    " Should we be checking for an exact match below?
	    " Or maybe not bothering to remove tags at all?
	    if (match(GetTagClass(tag), class) < 0)
		" Right name, but doesn't belong to right class
		call remove(tags, i)
	    else
		let i += 1
	    endif
	endwhile
    endif
    call UniqList(tags)
    return tags
endfunc

" Jump to the given tag.  flags is a string which may contain the following:
" 'h' - Hide current buffer before jumping to tag.
" 'd' - Debug mode.  Outputs debug message.
func! GoToTag(tag, flags)
    let hide = (a:flags =~ 'h')
    let debug = (a:flags =~ 'd')
    let tagFile = a:tag["filename"]
    let tagCmd = a:tag["cmd"]
    let tagClass = GetTagClass(a:tag)
    if (SameFiles(tagFile, '%'))
	1
    elseif (hide)
	exec 'silent hide e +0 ' . tagFile
    else
	exec 'silent e +0 ' . tagFile
    endif
    if (tagCmd[0] == '/')
	let tagCmd = tagCmd[1:]
	if (tagCmd[strlen(tagCmd) - 1] == '/')
	    let tagCmd = tagCmd[:-2]
	endif

	" Search will occasionally match more than one line.  Search for class
	" name first, as we know our tag will have to appear after that.  The
	" messy search below tries to make sure that we find the class/struct
	" definition, not just the type of some variable or function which may
	" precede that class.  First we find the word "class" or "struct".
	" Then we expect the class name.  Then, after skipping possible <..>
	" for templates, and "*" and "&" for pointers and references, we don't
	" want to find a C identifier.  We do all this for members of classes,
	" and for functions whose body appears inside the class declaration.
	" We presume the latter when the class name followed by "::" doesn't
	" appear before the tag name in the tag cmd.
	let tagKind = a:tag["kind"]
	if (tagClass != "" && ('mcsu' =~ tagKind ||
	    \ (tagKind == 'f' && tagCmd !~ (tagClass . '::'))))
	    " If the class is nested, need to search separately for each
	    " component, ignoring any anonymous structs.
	    let classes = split(tagClass, '::')
	    call filter(classes, 'v:val !~ "^__anon\\d\\+$"')
	    for class in classes
		call search('\<\(struct\|class\|union\)\>.*' .
			    \ escape('\<' . class . '\>', '*[]~') .
			    \ '\s*\(<[^<>]*>\s*\)*\(\*\|&\|\s\)*\(\<\H\|$\)',
			    \ 'c')
		"echo "Initial search: " . class . ", now line " . line(".")
	    endfor
	endif
	if (!search(escape(tagCmd, '*[]~'), 'c'))
	    " Try guessing
	    if (search('^[^/]*\<' . a:tag["name"] . '\>', 'c'))
		if (debug)
		    call Error("SmartTag: Couldn't find tag, just guessing")
		endif
	    else
		if (debug)
		    call Error("SmartTag: Couldn't find tag")
		endif
		return 0
	    endif
	endif
    else
	exec tagCmd
    endif
    return 1
endfunc

" 'tag' may be either a string (name of tag) or a structure like the entries in
" the array returned by taglist().  The name of the tag is returned.  If the
" tag represents a class, this function returns the true class name.  Eg a
" #define or typedef representing a class will be recognised and the class name
" is returned.
func! TrueClassName(tag)
    if (type(a:tag) == type(""))
	let class = StripTemplateEtc(a:tag)
	let tags = taglist('^' . class . '$')
	if (!exists("tags[0]"))
	    return class
	endif
	let tag = tags[0]   " When could there be more than one?
    else " If not a string, it should be a list
	let tag = a:tag
    endif
    let numIts = 0	" Count number of iterations to avoid endless loop
    while (1)
	let class = ""
	if (tag['kind'] == 't')	" typedef
	    if (has_key(tag, "typename") || has_key(tag, "typeref"))
		if (has_key(tag, "typeref"))
		    let class = tag["typeref"]
		else
		    let class = tag["typename"]
		endif
		" Strip off "struct:" or whatever at the front
		let class = substitute(class,
		    \ '^[^:]*:\([^:]\)', '\1', '')
	    else
		let cmd = tag["cmd"]
		let start = matchend(cmd, '^/^\s*typedef\s\+')
		if (start >= 0)
		    let last = match(cmd, '\s*\<' . tag["name"] . '\>', start)
		    if (last >= 0)
			let class = strpart(cmd, start, last - start)
		    endif
		endif
	    endif
	elseif (tag['kind'] == 'd')	" #define
	    " Ctags only matches part of the #define line, not giving us the
	    " thing it defines to.  Instead we need to follow the tag into its
	    " file.
	    let line = ""
	    let cmd = tag['cmd']
	    if (cmd[0] =~ '\d')
		if (filereadable(tag['filename']))
		    let file = readfile(tag['filename'])
		    let line = file[cmd - 1]
		endif
	    elseif (cmd[0] == '/')
		let cmd = cmd[1:]		" Strip leading /
		if (cmd[strlen(cmd) - 1] == '/')
		    let cmd = cmd[:-2]		" Strip trailing /
		endif
		let cmd = escape(cmd, '*[]~')
		if (filereadable(tag['filename']))
		    let file = readfile(tag['filename'])
		    for line in file
			if (line =~ cmd)
			    break
			endif
		    endfor
		endif
	    endif
	    let start = matchend(line, '^\s*#\s*define\s\+' . tag["name"]
				 \ . '\>\s\+')
	    if (start >= 0)
		let last = match(line, '.\>', start)
		if (last >= 0)
		    let class = strpart(line, start, last - start + 1)
		endif
	    endif
	endif
	if (class == "")
	    return StripTemplateEtc(tag["name"])
	endif
	let class = StripTemplateEtc(class)
	if (class == tag["name"])
	    return class	" Recursive
	endif
	if (numIts > 50)
	    return class	" Recursive probably
	endif
	let numIts += 1
	" Check that this isn't also a typedef or #define
	let tags = taglist('^' . class . '$')
	if (exists("tags[0]"))
	    let tag = tags[0]   " When could there be more than one?
	else
	    break
	endif
    endwhile
    return class
endfunc

" Return the given class name with its nesting expanded, based on the given
" tags list and scope.  Eg "Nested" may expand to "ClassB::Nested".
" If useScope is zero, do nothing.
func! ExpandClassNesting(class, tags, useScope, scope, splitClass)
    let class = a:class
    if (a:useScope)
	let scope = a:scope
	let i = -1
	if (a:splitClass)
	    let i = strridx(a:class, '::')
	endif
	if (i >= 0)
	    " Part of the nested class path is already in "class".
	    " Take it out and append it to the scope where it belongs.
	    let class = strpart(a:class, i + 2)
	    let scope .= "::" . strpart(a:class, 0, i)
	endif
	let longest = -1
	let best = ""
	let scopeLen = strlen(scope)
	for tag in a:tags
	    if (has_key(tag, "kind") && "csu" =~ tag["kind"])
		let tagClass = GetTagClass(tag)
		let len = strlen(tagClass)
		if (len > longest && scopeLen >= len &&
		    \ scope[0:len-1] == tagClass &&
		    \ (scopeLen == len || scope[(len):len+1] == "::"))
		    let best = tagClass
		    let longest = len
		endif
	    endif
	endfor
	if (best != "")
	    " Prepend with nested class names
	    let class = best . "::" . class
	endif
    endif
    return class
endfunc

" Return list of all base classes (including self), with derived classes first
" and base classes last.  If nameOnly is zero, then typedefs or #defines
" found along the way are also included, and all types are spelt out in full.
" Otherwise just the basic tag name of the type is included.
" If useScope is non-zero, then scope is used to define the class-scope where
" the resultant classes are expected to be found, eg "ClassB::Nested", in which
" case resultant classes for "type" should be found, in order of preference, in
" one of:
"   ClassB::Nested::Nested2
"   ClassB::Nested2
"   Nested2
" When useScope is non-zero, the class names will also have their full nested
" paths expanded.
func! GetBaseClasses(type, nameOnly, useScope, scope, splitClass)
    let class = a:type
    if (a:nameOnly)
	let class = StripTemplateEtc(class)
    endif
    if (class == "")
	return [class]
    endif
    let oldIc = &ic
    set noic
    let tags = UniqTagList(class, a:splitClass)
    let class = ExpandClassNesting(class, tags, a:useScope, a:scope,
				   \ a:splitClass)
    let classes = [class]

    let i = 0
    while (exists("tags[i]"))
	"echo 'tag ' . i . '/' . len(tags) . ': ' . tags[i]["name"] .
		"\ ', kind ' tags[i]["kind"]
	if (has_key(tags[i], "inherits"))
	    let class = tags[i]["inherits"]
	    if (a:nameOnly)
                " If we don't do this then the split() below could go wrong if
                " commas appear inside template lists or something.
		let class = StripTemplateEtc(class)
	    endif
	    let newClasses = reverse(split(class, ","))
	    call extend(classes, newClasses)
	    if (!a:nameOnly)
		" Need a stripped version now regardless
		let class = StripTemplateEtc(tags[i]["inherits"])
		let newClasses = reverse(split(class, ","))
	    endif
	    let j = 0
	    while (exists("newClasses[j]"))
		let class = newClasses[j]
		let newTags = UniqTagList(class, a:splitClass)
		let class = ExpandClassNesting(class, newTags, a:useScope,
					       \ a:scope, a:splitClass)
		let newClasses[j] = class
		for tag in newTags
		    if ((tag["kind"] == 'd' || tag["kind"] == 't') &&
			\ index(tags, tag) < 0)
			call add(tags, tag)
		    endif
		endfor
		let j += 1
	    endwhile
	elseif (tags[i]["kind"] != 'f')
	    let class = TrueClassName(tags[i])
	    if (class != StripTemplateEtc(tags[i]["name"]))
		let newTags = UniqTagList(class, a:splitClass)
		call extend(tags, newTags)
		let class = ExpandClassNesting(class, newTags, a:useScope,
					       \ a:scope, a:splitClass)
		call add(classes, class)
	    endif
	endif
	let i += 1
    endwhile
    let &ic = oldIc
    call UniqList(classes)
    return classes
endfunc

" Return the name of the class/struct/union that the given taglist item belongs
" to, or "" if it's global.
func! GetTagClass(tag)
    if (has_key(a:tag, "class"))
	return a:tag["class"]
    endif
    if (has_key(a:tag, "struct"))
	return a:tag["struct"]
    endif
    if (has_key(a:tag, "union"))
	return a:tag["union"]
    endif
    return ""
endfunc

" Return true if the given taglist item is of the given class (or struct).
" If class is "", then only return true for global items.
func! TagInClass(tag, class)
    return GetTagClass(a:tag) == a:class
endfunc

" Return the type of the given item from a taglist, or "" if we can't figure it
" out.  For functions, it's the return type we're interested in.
func! TagType(tag, nameOnly)
    if (has_key(a:tag, "typename") || has_key(a:tag, "typeref"))
	" This makes it easy
	if (has_key(a:tag, "typeref"))
	    let type = a:tag["typeref"]
	else
	    let type = a:tag["typename"]
	endif
	" Skip "struct:" or "class:" etc.
	let i = stridx(type, ":") + 1
	return type[(i):]
    endif
    let cmd = a:tag["cmd"]
    if (cmd[0] != '/')
	return ""	" Can't figure it out without a search pattern
    endif
    if (has_key(a:tag, "kind") && 'vmf' !~ a:tag["kind"])
	return ""	" Want a variable, member or function
    endif
    let i = 1
    if (cmd[i] == '^')
	let i += 1
    endif
    let i = match(cmd, '[^	 {]', i)
    let origIdPos = match(cmd, a:tag["name"], i)
    if (origIdPos < 0)
	" Search pattern doesn't contain original identifier, weird.
	return ""
    endif
    let j = matchend(cmd, '^\(' . s:PreTypeSkip . '\s\+\)\+', i)
    if (j >= 0)
	let i = j
    endif
    if (cmd[i] !~ '\h')
	return ""	" Expected an identifier
    endif
    " Do include the following in the type name
    let j = matchend(cmd, '^\(' . s:PreTypeInclude . '\s\+\)\+', i)
    if (j >= 0)
	if (cmd[j] !~ '\h')
	    return ""	" Expected an identifier
	endif
	if (a:nameOnly)
	    let i = j
	endif
    endif
    let j = matchend(cmd, '^\w\+\(\s*\(<[^<>]*>\s*\)*::\s*\h\+\)*', i)
    if (j < 0)
	let type = strpart(cmd, i)
	let j = len(cmd)
    else
	let type = strpart(cmd, i, j + 1 - i)
	let k = match(cmd, '\S', j)
	if (cmd[k] == ',')
	    " Shouldn't be a comma after type and before first variable.
	    " Probably means type was on previous line and missing from tag
	    " command.
	    let origIdPos = -1
	elseif (!a:nameOnly)
	    let last = match(cmd, a:tag["name"], j)
	    let k = last - 1
	    while (k >= j && match(cmd[k], '[	 *&]') >= 0)
		let k -= 1
	    endwhile
	    let k += 1
	    let k = matchend(cmd, '^\s*', k)
	    if (k < last)
		let type .= ' ' . strpart(cmd, k, last - k)
	    endif
	endif
    endif
    if (origIdPos >= 0)
	let type = StripTemplateEtc(type)
	let type = substitute(type, '\s\+', '', 'g')
    endif

    " Function name may not include type in tag cmd (when it's on the line
    " before).  Need to jump to the tag and look there instead.
    if (j >= origIdPos && has_key(a:tag, "kind") && 'vmf' =~ a:tag["kind"])
	let oldBuf = bufnr("%")
	let oldPos = getpos(".")
	if (GoToTag(a:tag, 'h'))
	    " First, move cursor to column for our identifier.
	    let line = getline(".")
	    let col = match(line, a:tag["name"])
	    normal 0
	    if (col > 0)
		exec 'normal ' . col . 'l'
	    endif
	    let type = FindDeclarationType()
	    if (type != "")
		let isLocal = 1
	    endif
	endif
	exec 'buffer ' . oldBuf
	call setpos(".", oldPos)
    endif
    return type
endfunc

" Add the "types" fields to the given tags list.  If nameOnly is
" non-zero then just include the name (without *, &, <..> etc).
func! AddTypeLists(tags, nameOnly)
    for tag in a:tags
	let type = TagType(tag, a:nameOnly)
	let scope = GetTagClass(tag)
	let len = len(scope)
	let splitClass = 1
	if (scope == "" || (strpart(type, 0, len) == scope &&
			    \ type[(len):len+1] == "::"))
	    " Type already includes scope.  This is probably the case most of
	    " the time, eg full class path was obtained from "typeref" field of
	    " tag.  An example when we need splitClass is b.mNested12.mNA in
	    " the test file.
	    let splitClass = 0
	endif
	let tag["types"] = GetBaseClasses(type, a:nameOnly, 1, scope,
					  \ splitClass)
    endfor
endfunc

" Add the "trueClass" fields to the given tags list.
func! AddTrueClassFields(tags)
    if (!exists('a:tags[0]["trueClass"]'))
	for tag in a:tags
	    " Any need to expand typedefs or #defines here?  I don't think
	    " they'll ever appear.
	    "TODO: Was it like this for a reason?
	    "if (tag["kind"] =~ '[cs]')
		"let tag["trueClass"] = tag["name"]
		"let scope = GetTagClass(tag)
		"if (scope != "")
		    "let tag["trueClass"] = scope . "::" . tag["trueClass"]
		"endif
	    "else
		let tag["trueClass"] = GetTagClass(tag)
	    "endif
	endfor
    endif
endfunc

" Count number of arguments in given function declaration, which should include
" an opening "(", and preferably a closing one too.  Returns a dictionary with
" two items: min and max.  For function calls, ignore min.
func! CountArgs(decl)
    " Might be commas inside (..) as part of some args, so remove those
    " first, then we can count commas.
    let sig = a:decl
    " Remove leading "("
    let sig = substitute(sig, '^[^(]*(\s*', '', '')
    let prevSig = ""
    while (sig != prevSig)
	let prevSig = sig
	let sig = substitute(sig, '([^()]*)', '', 'g')
    endwhile
    let min = 0
    let max = 0
    let end = match(sig, ')')
    if (end < 0)
	let max = 99999
    else
	let sig = strpart(sig, 0, end)
    endif
    " Might also be commas inside <..> or [..], so remove those.
    let prevSig = ""
    while (sig != prevSig)
	let prevSig = sig
	let sig = substitute(sig, '<[^<>]*>', '', 'g')
	let sig = substitute(sig, '\[[^][]*\]', '', 'g')
    endwhile
    if (match(sig, '^\s*$') < 0 && match(sig, '^\s*void\s*$') < 0)  " Has args
	let min += 1
	let max += 1
	let gotEquals = 0
	let len = strlen(sig)
	let i = 0
	while (i < len)
	    if (sig[i] == ',')
		let max += 1
		if (!gotEquals && match(sig, '^\W*$', i + 1) < 0)
		    let min += 1
		endif
	    elseif (sig[i] == '=' && !gotEquals)
		let gotEquals = 1
		let min -= 1
	    elseif (sig[i] == '.' && sig[i + 1] == '.' && sig[i + 2] == '.')
		" Variable arg list
		let max = 99999
		break
	    endif
	    let i += 1
	endwhile
    endif
    let num = {}
    let num["min"] = min
    let num["max"] = max
    return num
endfunc

" Add the "minArgs" and "maxArgs" fields to the given taglist.
func! AddNumArgsFields(tags)
    for tag in a:tags
	let tag["minArgs"] = 0
	let tag["maxArgs"] = 99999
	if (tag["kind"] == 'f')
	    if (has_key(tag, "signature"))
		let num = CountArgs(tag["signature"])
		let tag["minArgs"] = num["min"]
		let tag["maxArgs"] = num["max"]
	    elseif (tag["cmd"][0] == '/')
		" No "signature" field.  Let's see what we can figure out from
		" the search cmd.
		let num = CountArgs(tag["cmd"])
		let tag["minArgs"] = num["min"]
		let tag["maxArgs"] = num["max"]
	    endif
	endif
    endfor
endfunc

" Show the state of the tag list
func! DebugTagLists(title, tagLists, debug)
    if (!a:debug)
	return
    endif
    echo a:title
    let lev = 0
    while (exists("a:tagLists[lev]"))
	echo "  level " . lev
	call AddTrueClassFields(a:tagLists[lev])
	for tag in a:tagLists[lev]
	    let str = "   "
	    if (has_key(tag, "kind"))
		let str .= tag["kind"] . " "
	    endif
	    if (has_key(tag, "trueClass"))
		let str .= "class: " . tag["trueClass"] . "; "
	    endif
	    if (has_key(tag, "types"))
		let str .= "types: "
		for type in tag["types"]
		    let str .= type . ", "
		endfor
	    endif
	    if (has_key(tag, "typeIndex"))
		let str .= "typeIdx " . tag["typeIndex"] . "; "
	    endif
	    if (has_key(tag, "nice"))
		let str .= "nice; "
	    endif
	    if (has_key(tag, "argError"))
		let str .= "argError " . tag["argError"] . " (min " . 
		    \ tag["minArgs"] . ", max " . tag["maxArgs"] . "); "
	    endif
	    if (has_key(tag, "fileMatchLen"))
		let str .= "fileMatchLen " . tag["fileMatchLen"] . "; "
	    endif
	    echo str
	endfor
	let lev += 1
    endwhile
endfunc

" Used with sort() to sort a list of tags.  Sort on the "typeIndex" field
" first, if present.  Then on the "nice" field.  Then "argError".
" Then "fileMatchLen".  These are all fields we add ourselves along the way to
" find the best tag.
func! TagClassCmp(tag1, tag2)
    if (has_key(a:tag1, "typeIndex") && has_key(a:tag2, "typeIndex"))
	if (a:tag1["typeIndex"] < a:tag2["typeIndex"])
	    return -1
	elseif (a:tag1["typeIndex"] > a:tag2["typeIndex"])
	    return 1
	endif
    endif
    if (has_key(a:tag1, "nice") && !has_key(a:tag2, "nice"))
	return -1
    elseif (!has_key(a:tag1, "nice") && has_key(a:tag2, "nice"))
	return 1
    elseif (has_key(a:tag1, "argError") && has_key(a:tag2, "argError"))
	if (a:tag1["argError"] < a:tag2["argError"])
	    return -1
	elseif (a:tag1["argError"] > a:tag2["argError"])
	    return 1
	endif
    endif
    if (has_key(a:tag1, "fileMatchLen") && has_key(a:tag2, "fileMatchLen"))
	if (a:tag1["fileMatchLen"] > a:tag2["fileMatchLen"])
	    return -1
	elseif (a:tag1["fileMatchLen"] < a:tag2["fileMatchLen"])
	    return 1
	endif
    endif
    return 0
endfunc

" OpsTable: array with three entries, for C++ operators with 1, 2 and 3
" characters.  Each entry is a dictionary mapping the operator to a string of
" flags:
" < Pre-unary
" > Post-unary
" 2 Binary
" + Has an extra arg when post-unary, eg [] which is unary, but is passed an
"   index, and ++ and -- both have an extra unused arg in their post-unary
"   forms.  An operator may have more than one flag.
silent! unlet OpsTable
let OpsTable = []
call add(OpsTable, {'[' : '>+', ']' : '>+', '(' : '<>', ')' : '<>', '~' : '<',
	 \ '!' : '<', '&' : '<2',
	 \ '*' : '<2', '+' : '<2', '-' : '<2', ',' : '2', '%' : '2', '/' : '2',
	 \ '<' : '2', '>' : '2', '=' : '2', '^' : '2', '|' : '2'})
call add(OpsTable, {'++' : '<>+', '--' : '<>+', '+=' : '2', '-=' : '2',
	 \ '->' : '2', '!=' : '2', '%=' : '2', '&&' : '2', '&=' : '2',
	 \ '*=' : '2', '/=' : '2', '<<' : '2', '<=' : '2', '==' : '2',
	 \ '>=' : '2', '>>' : '2', '^=' : '2', '|=' : '2', '||' : '2'})
call add(OpsTable, {'->*' : '2', '<<=' : '2', '>>=' : '2'})

" GetNiceTagList() should be passed an empty array in niceTags, which is filled
" with nice tags for the item under the cursor.
"
" This may include adding the "type" field to each tag, and putting tags in a
" good order based on context.
"
" Function returns the name of the tag searched for.
"
" Flags:
" "n" - Name only
" "t" - Fill in the "types" field for tags.  TODO: Needs work.
" "k" - Keep bad tags, ie tag list is just reordered, but all entries are kept.
" "d" - Debug
func! GetNiceTagList(niceTags, flags)
    let nameOnly = (a:flags =~ 'n')
    let needTypes = (a:flags =~ 't')
    let keepBadTags = (a:flags =~ 'k')
    let debug = (a:flags =~ 'd')
    let oldWin = winsaveview()
    if (exists("&tagfunc"))
	" Don't want our calls to taglist() to act recursively.
	let oldTagFunc = &tagfunc
	let &tagfunc = ""
    endif
    let oldIc = &ic
    set noic
    let oldMatchpairs = &matchpairs
    set matchpairs+=<:>
    let numArgs = -1
    let done = 0
    let level = 0
    let tagLists = []
    let badTags = []
    call StepForwardNonComment('\S', 'c')   " Skip any leading space
    let line = getline(".")
    let col = col(".") - 1
    let op = ""
    let opFlags = ""
    let origWord = expand("<cword>")
    let gotOpWord = 0
    let wantDestructor = 0
    if (line[col] =~ '\w' && (origWord == "operator" || origWord == "goto"))
	" Want the operator after the word "operator"
	if (origWord == "operator")
	    let gotOpWord = 1
	endif
	call StartOfWord()
	normal w
	let line = getline(".")
	let col = col(".") - 1
    endif
    if (line[col] !~ '\w')
	" Could be an operator
	let i = 2
	while (i >= 0 && op == "") " First try starting from the left
	    let j = 2
	    while (j >= i)	" For each length of operators (minus 1)
		if (col >= i &&
		    \ exists("g:OpsTable[j][strpart(line, col - i, j + 1)]"))
		    let op = strpart(line, col - i, j + 1)
		    let opFlags = g:OpsTable[j][op]
		    " Move cursor back to start of match
		    if (i > 0)
			exec 'normal ' . i . 'h'
		    endif
		    break
		endif
		let j -= 1
	    endwhile
	    let i -= 1
	endwhile
    else
	" Could still be an operator, eg new or delete (or a type cast?)
	let origWord = expand("<cword>")
	if (gotOpWord)
	    let op = origWord
	    let len = strlen(line)
	    let col = match(line, '\W', col)
	    if (col >= 0)
		while (col < len)		" Append pointers.
		    if (line[col] == '*')
			let op .= '*'
		    elseif (line[col] !~ '\s')
			break
		    endif
		    let col += 1
		endwhile
	    endif
	    let opFlags = "<"	" Pre-unary
	elseif (origWord == "new")
	    let op = "new"
	    let opFlags = "<"	" Pre-unary
	    normal wb
	elseif (origWord == "delete")
	    let op = "delete"
	    let opFlags = "<"	" Pre-unary
	    normal wb
	else
	    let oldCursor = getpos(".")
	    call StartOfWord()
	    call StepBackNonComment('\S', '#')
	    let prevWord = expand("<cword>")
	    call setpos('.', oldCursor)
	    if (prevWord == "goto")
		let lnum = search('^\s*' . origWord . '\s*:\([^:]\|$\)', 'nW')
		if (lnum > 0)
		    let tags = []
		    call add(tags, {})
		    let tags[0]["name"] = origWord
		    let tags[0]["filename"] = expand("%")
		    let tags[0]["cmd"] = "" . lnum
		    "let tags[0]["kind"] = "g"	" Made-up kind for goto?
		    if (debug)
			echo " Goto " . origWord
			echo tags[0]
		    endif
		    let &matchpairs = oldMatchpairs
		    let &ic = oldIc
		    if (exists("&tagfunc"))
			let &tagfunc = oldTagFunc
		    endif
		    call winrestview(oldWin)
		    call extend(a:niceTags, tags)
		    return origWord
		endif
	    endif
	endif
    endif
    if (op != "")
	if (op == ']' || op == ')')
	    " Go to opening bracket
	    let oldCursor = getpos(".")
	    normal %
	    let op = CursorChar()
	    if (op != '[' && op != '(')
		let op = ""
		call setpos('.', oldCursor)
	    endif
	endif
	if (op == '[')
	    let op = '[]'
	endif
	if (op == '(')
	    let op = '()'
	endif
	if (op == '()' && !gotOpWord)
	    " TODO: Check if it's a cast, then the type inside () becomes the
	    " op instead.  Parentheses are confusing.  They could be any of
	    " these forms:
	    " func(blah)	" Function call
	    " var(blah)		" Could be constructor args or operator
	    " type(var)		" Cast var to type
	    " (type) var	" Cast var to type
	    " ((type) var)->m
	    " (a + b) * c
	    " So for now, treating () as an operator will probably just cause
            " confusion.  Operator () is pretty rare anyway isn't it?
	    let op = ''
	endif
    endif
    if (op != "")
	" Look for word "operator" before the op
	let line = getline(".")
	let col = col(".") - 2
	while (col > 0 && line[col] =~ '\s')
	    let col -= 1
	endwhile
	if (col >= 7 && strpart(line, col - 7, 8) == 'operator')
	    let gotOpWord = 1
	endif
	let tags = UniqTagList('operator ' . escape(op, '*[]~'), 0)
	if (op == 'delete')
	    " No delete operator, so let's jump to the destructor instead.
	    let wantDestructor = 1
	endif
	if (empty(tags) && !wantDestructor)
	    let op = ""
	elseif (gotOpWord)
	    " "operator" word given explicitly so don't check for
	    " pre/post-unary or binary via context.
	    let finalClass = GetThisClass()
	    let wantDestructor = 0
	    if (debug)
		echo 'Explicit operator ' . op
	    endif
	else
	    " Check for ID before and/or after.  May have to skip other unary
	    " ops first (pre-unary ones after or post-unary ones before).

	    " Check which op-flag to use and prepare to find type of identifier
	    " on left or right accordingly.
	    let hasIdAfter = 0
	    let hasIdBefore = 0
	    let preUnary = 0
	    let opPos = getpos(".")
	    if (opFlags =~ '<' || opFlags =~ '2')
		" See if there's an identifier to the right.
		" Go to end of operator
		let len = strlen(op)
		if (len > 1)
		    exec 'normal ' . (len - 1) . 'l'
		endif
		while (1)
		    " Skip space and opening brackets
		    if (!search('[^	 (]', 'W'))
			break
		    endif
		    let line = getline(".")
		    let col = col(".") - 1
		    " Skip over any pre-unary ops.
		    let i = 2
		    while (i >= 0)
			let var = "g:OpsTable[i][strpart(line, col, i + 1)]"
			if (exists(var))
			    exec 'let flags = ' . var
			    if (flags =~ '<')
				if (i > 0)
				    exec 'normal ' . i . 'l'
				endif
				break
			    endif
			endif
			let i -= 1
		    endwhile
		    if (i < 0)
			break	" Didn't find a pre-unary op
		    endif
		endwhile
		" Don't use \h below since "a + 3" is valid.
		if (CursorChar() =~ '\w')
		    let hasIdAfter = 1
		    let afterPos = getpos(".")
		endif
	    endif
	    if (opFlags =~ '>' || opFlags =~ '2')
		" See if there's an identifier to the left.
		call setpos('.', opPos)
		while (1)
		    " Skip space and comments
		    if (StepBackNonComment('\S', '#') <= 0)
			break
		    endif
		    let line = getline(".")
		    let col = col(".") - 1
		    if (line[col] =~ '[])]')
			normal %
			continue
		    endif
		    " Skip over any post-unary ops.
		    let i = 2
		    while (i >= 0)
			let var = "g:OpsTable[i][strpart(line, col - i, i + 1)]"
			if (exists(var))
			    exec 'let flags = ' . var
			    if (flags =~ '>')
				if (i > 0)
				    exec 'normal ' . i . 'h'
				endif
				break
			    endif
			endif
			let i -= 1
		    endwhile
		    if (i < 0)
			break	" Didn't find a post-unary op
		    endif
		endwhile
		let c = CursorChar()
		if (c =~ '\w')
		    let hasIdBefore = 1
		    "let beforePos = getpos(".")
		endif
	    endif
	    if (hasIdBefore && hasIdAfter && opFlags =~ '2')
		let numArgs = 1
		if (debug)
		    echo 'Binary operator ' . op
		endif
	    elseif (hasIdBefore && opFlags =~ '>')
		let numArgs = 0
		if (debug)
		    echo 'Post-unary operator ' . op
		endif
	    endif
	    if (numArgs >= 0)
		" Need to find type of identifier on the left.
		call setpos('.', opPos)
		while (1)
		    call StepBackNonComment('[])a-zA-Z_0-9]', '#')
		    let c = CursorChar()
		    if (c != ')' && c != ']')
			break
		    endif
		    normal %
		endwhile
	    elseif (hasIdAfter && opFlags =~ '<')
		" Appears to be pre-unary, which means we need to check the
		" identifier on the right.  Everything else checks from right
		" to left.  Need to search past any p->m.a[4]->b(4).c sequence
		" to right-most term, then later search back to the left as
		" usual to determine its type.  Some examples for unary "-":
		" -var		    " Op for type of var
		" delete var	    " Op for type of var
		" -(var + var2)	    " Probably use op for type of var
		" -(Type)var	    " Use op for Type
		" -2		    " Don't want op here
		" -func()	    " Op for type returned by func()
		" -((Type*)a)->b.c  " Op for type of c
		call setpos('.', afterPos)
		let preUnary = 1
		let numArgs = 0
		if (debug)
		    echo "Pre-unary operator " . op
		endif
		" Skip past any p->m.a[4]->b(4).c sequence
		" TODO: Leading '(' could confuse us.  Oh well.
		while (CursorChar() =~ '\h' && search('\W', 'W'))
		    let line = getline(".")
		    let col = col(".") - 1
		    let c = line[col]
		    while (c == '[' || c == '(' || c == '<')
			normal %
			if (CursorChar() == c)
			    break	" % failed
			endif
			call StepForwardNonComment()
			let line = getline(".")
			let col = col(".") - 1
			let c = line[col]
		    endwhile
		    if (c == '.')
			call StepForwardNonComment()
		    elseif ((c == '-' && line[col + 1] == '>') ||
			    \ (c == ':' && line[col + 1] == ':'))
			normal l
			call StepForwardNonComment()
		    endif
		endwhile
		call search('\w', 'bW')
	    endif
	    if (numArgs >= 0 && hasIdBefore && opFlags =~ '+')
		let numArgs += 1
	    endif
	endif
	if (wantDestructor)
	    " We figured out above that no delete operator could be found.
	    " So we'll look for the destructor instead.
	    let op = ""
	endif
	if (op != "")
	    if (needTypes)
		call AddTypeLists(tags, nameOnly)
	    endif
	    call add(tagLists, tags)
	    call DebugTagLists(" Operator tags:", tagLists, debug)
	    let level += 1
	endif
    endif
    if (op != "")
	let origWord = 'operator ' . op
    else
	call StartOfWord()
	let origWord = expand("<cword>")
    endif
    let origWordPos = getpos(".")
    while (1)
	if (exists("finalClass"))
	    if (debug)
		echo "Level " . level . ": finalClass " . finalClass
	    endif
	else
	    let id = expand("<cword>")
	    " Create a list of possible tags for the id
	    normal wb
	    let oldCursor = getpos(".")
	    let col = col(".") - 1
	    if (level == 0 && col > 0 &&
		\ getline(".")[0:col - 1] =~ '^\s*\(virtual\)\=\s*\~$')
		let id = '\~' . id   " For destructors include the ~
		normal h
	    endif
	    let tags = UniqTagList(id, 0)
	    if (level > 0 || needTypes)
		call AddTypeLists(tags, nameOnly)
	    endif
	    call StepBackNonComment()
	    let line = getline(".")
	    let col = col(".") - 1
	    if (debug)
		echo "Level " . level . ": " . id
	    endif
	endif
	if (exists("finalClass"))
	    " Figured out the final class last time around
	    unlet tags
	    let tags = []
	    call add(tags, {})
	    let tags[0]["name"] = finalClass
	    let tags[0]["kind"] = "c"
	    let tags[0]["types"] = GetBaseClasses(finalClass, nameOnly, 1,
						  \ GetThisClass(), 0)
	    let done = 1
	elseif (col > 0 && line[col-1:col] == "::")
	    " Identifier is preceded by a class or it's explicitly global
	    normal h
	    call StepBackNonComment()
	    call SkipBackOverTemplate()
	    let c = CursorChar()
	    if (match(c, '\w') < 0)	" No identifier under cursor
		" Explicitly global, eg ::glob
		let class = ""
		if (debug)
		    echo " Explicitly global"
		endif
	    else
		" Class name is given, eg Class::Class2::Class3::mMember
		let class = expand("<cword>")
		normal wb
		call StepBackNonComment()
		let line = getline(".")
		let col = col(".") - 1
		while (col > 0 && line[col-1:col] == "::")
		    normal h
		    call StepBackNonComment()
		    call SkipBackOverTemplate()
		    let c = CursorChar()
		    if (match(c, '\w') < 0)	" No identifier under cursor
			break
		    endif
		    let preClass = expand("<cword>")
		    let preClass = TrueClassName(preClass)
		    let class = preClass . "::" . class
		    normal wb
		    call StepBackNonComment()
		    let line = getline(".")
		    let col = col(".") - 1
		endwhile
		if (debug)
		    echo " Preceded by explicit class " . class
		endif
	    endif
	    let finalClass = class
	elseif (line[col] == '.' ||
		\ (line[col] == '>' && col > 0 && line[col - 1] == '-'))
	    " Identifier is a member of some class.  Put cursor on previous
	    " identifier for next time around the loop.
	    if (line[col] == '>')
		normal h
	    endif
	    call StepBackNonComment()
	    while (1)
		" Skip back past array index/function args/template
		let c = CursorChar()
		if ('])>' !~ c)
		    break
		endif
		normal %
		if (c == ')')
		    " These may be args to a function, in which case we need to
		    " search back for the function name and then find the type
		    " it returns.  Or, the () could just be indicating operator
		    " precedence.  In this situation it would usually be in
		    " order to perform a cast.  Quick and dirty way to check
		    " for this is to see if there's a second opening "(".  If
		    " so, it's likely a cast, and the final type is given in
		    " those inner brackets.
		    let tmpPos = getpos(".")
		    call StepForwardNonComment()
		    if (CursorChar() == '(')
			" Looks like it might be a cast.  Check that character
			" before first "(" won't evaluate to a function name.
			call setpos('.', tmpPos)
			call StepBackNonComment()
			let c = CursorChar()
			if (c !~ '\w' && c !~ '[]>]')
			    " Looks like a cast alright.  Find type name after
			    " inner bracket.
			    call setpos('.', tmpPos)
			    call StepForwardNonComment()    " Skip to "("
			    call StepForwardNonComment('[^	 *&]')
			    if (CursorChar() =~ '\w')
				let finalClass = expand("<cword>")
				let finalClass = TrueClassName(finalClass)
				if (debug)
				    echo " C-style cast to type " . finalClass
				endif
				break
			    endif
			endif
		    endif
		    call setpos('.', tmpPos)
		endif
		call StepBackNonComment()
	    endwhile
	    " If identifier under cursor is now a C++ cast operator, then we
	    " presumably went back past (..) first, then past <..>.  Look
	    " forward to find the type between <..> and use it next time around
	    " the loop.
	    let preId = expand("<cword>")
	    if (!exists("finalClass") &&
		\ (preId == "dynamic_cast" || preId == "static_cast" ||
		\ preId == "const_cast" || preId == "reinterpret_case" ||
		\ preId == "safe_cast"))
		normal w
		let line = getline(".")
		if (line[col(".") - 1] == "<")
		    call StepForwardNonComment()
		    let col = col(".") - 1
		    call StepBackNonComment()
		    normal %
		    call StepBackNonComment()
		    let finalClass = strpart(line, col, col(".") - col)
		    let finalClass = TrueClassName(finalClass)
		    if (debug)
			echo " C++ cast found to type " . finalClass
		    endif
		endif
	    endif
	else
	    " No preceding class.  Could be a member of the local class, or a
	    " local var, or a global.  See if we can find it as a local var.
	    let isLocal = 0
	    let type = ""
	    call setpos('.', oldCursor)
	    let class = GetThisClass()	" To set g:IsInFunctionBody
	    if (debug)
		echo " Current context is class <" . class . ">"
	    endif
	    if (id == "this")
		let isLocal = 1
		let type = class
	    elseif (g:IsInFunctionBody)
		" Is it better to do :normal 99999[{ then search forward?
		" Probably not as searchdecl() skips comments etc, and can find
		" a match earlier than the "{", in the function header.
		" Could also be stray open braces in comments which would
		" stuff [{ up.
		call searchdecl(id, 0, 1)
		let wasPos = getpos(".")
		let type = FindDeclarationType()
		if (type != "")
		    let isLocal = 1
		endif
		call setpos('.', wasPos)
	    endif
	    if (isLocal)
		if (level == 0)
		    call extend(badTags, tags)
		endif
		unlet tags
		let tags = []
		call add(tags, {})
		let tags[0]["name"] = id
		let tags[0]["filename"] = expand("%")
		let tags[0]["cmd"] = "" . line(".")
		let tags[0]["kind"] = "v"
		let tags[0]["types"] = GetBaseClasses(type, nameOnly, 0, "", 0)
		let done = 1
		if (debug)
		    echo " Local var " . id . " of type " . type
		    echo tags[0]
		endif
	    elseif (empty(tags))
		" Not a local, but no tags, so give up.
		let done = 1
	    else
		" Couldn't find it as a local var.  See if we can find it as a
		" member of the current class, or as a global whose type we
		" hope to find contained in the ex cmd for the tag.
		call setpos('.', oldCursor)	" Still required?
		if (class != "")
		    let classes = GetBaseClasses(class, 1, 0, "", 0)
		    let minIndex = 999999
		    for tag in tags
			let tagClass = substitute(GetTagClass(tag),
						  \ '::__anon\d\+$', '', '')
			let idx = index(classes, tagClass)
			if (idx >= 0 && idx < minIndex)
			    let minIndex = idx
			    let finalClass = tagClass
			    if (debug)
				let msg = ' ' . id . ' is member of "this" (' .
				    \ finalClass . '), types '
				if (has_key(tag, "types"))
				    let msg .= string(tag["types"])
				else
				    let msg .= '<unknown>'
				endif
				let msg .= '(index ' . idx . ')'
				echo msg
			    endif
			    if (idx == 0)
				break
			    endif
			endif
		    endfor
		endif
		if (!exists("finalClass"))  " Try a global
		    for tag in tags
			if (TagInClass(tag, ""))
			    let done = 1
			    if (debug)
				echo " Global identifier"
			    endif
			    break
			endif
		    endfor
		    "if (done && id[0] != '~')
			" Found it as a global.  Remove other tags, except for
			" constructors and deconstructors, which we consider to
			" be global.
			"let i = len(tags) - 1
			"while (i >= 0)
			    "if (!TagInClass(tags[i], "") &&
				""TODO: could be class or struct below.
				"\ tags[i]["name"] != tags[i]["class"])
				"call remove(tags, i)
			    "endif
			    "let i -= 1
			"endwhile
		    "endif
		endif
		if (!exists("finalClass") && !done)  " Give up
		    let done = 1
		    if (debug)
			echo " Not local, not a member of this, and not global"
		    endif
		endif
	    endif
	endif
	call add(tagLists, tags)
	call DebugTagLists(" Before removing bad tags:", tagLists, debug)
	if (level > 0)
	    " Remove types from tagLists[level] which aren't classes from
	    " tagLists[level - 1]
	    call AddTrueClassFields(tagLists[level - 1])
	    let i = len(tags) - 1
	    while (i >= 0)	" For each type at [level]
		let found = 0
		for tag in tagLists[level - 1]	" For each class at [level - 1]
		    if (has_key(tags[i], "types") && has_key(tag, "trueClass"))
			" Loop to strip off any "::__anon123" from the end of
			" the class name and attempt match again.  When unnamed
			" nested structs have a member name, the __anon will
			" match too, otherwise it won't, so try both ways.
			let c = tag["trueClass"]
			let oldC = "---"	" Anything that can't equal c
			while (c != oldC)
			    " Does the class of our identifier match a possible
			    " type for the identifier up one level?
			    if (index(tags[i]["types"], c) >= 0)
				let found = 1
				break
			    endif
			    let oldC = c
			    let c = substitute(c, '::__anon\d\+$', '', '')
			endwhile
			if (found)
			    break
			endif
		    endif
		endfor
		if (!found)
		    call remove(tagLists[level], i)
		    " Or: call remove(tags, i)?
		endif
		let i -= 1
	    endwhile
	endif
	let lev = level - 1
	while (lev >= 0)    " For each level starting at highest (leftmost).
	    " Remove classes from tagLists[lev] which aren't types from
	    " tagLists[lev + 1]
	    let removedSomething = 0
	    let i = len(tagLists[lev]) - 1
	    while (i >= 0)	" For each class at [lev]
		let worstIdx = -1
		let idx = -1
		for tag in tagLists[lev + 1]	" For each type at [lev + 1]
		    if (has_key(tagLists[lev][i], "trueClass") &&
			\ has_key(tag, "types"))
			" Loop to strip off any "::__anon123" from the end of
			" the class name and attempt match again.  When unnamed
			" nested structs have a member name, the __anon will
			" match too, otherwise it won't, so try both ways.
			let c = tagLists[lev][i]["trueClass"]
			let oldC = "---"	" Anything that can't equal c
			while (c != oldC)
			    let idx = index(tag["types"], c)
			    if (idx >= 0)
				break
			    endif
			    " When tagging from a class name when we're in a
			    " method of that class, don't throw it away.  We
			    " might want to tag to the class, not the
			    " constructor.  The class won't be found above
			    " because it isn't a member of itself, but don't
			    " remove it in this special case.
			    if (level == 1 && lev == 0 &&
				\ exists("finalClass") &&
				\ finalClass == origWord)
				let idx = 0
				break
			    endif
			    let oldC = c
			    let c = substitute(c, '::__anon\d\+$', '', '')
			endwhile
			if (idx >= 0)
			    if (idx > worstIdx)
				let worstIdx = idx
			    endif
			    if (lev > 0)
				" At level zero keep searching for the type
				" match which is furthest down the list of
				" types, ie more towards the base class end.
				" Later we'll want ones closer to the derived
				" end to appear first in sort order.
				break
			    endif
			endif
		    endif
		endfor
		if (worstIdx < 0)
		    if (lev == 0)
			call insert(badTags, tagLists[lev][i])
		    endif
		    call remove(tagLists[lev], i)
		    let removedSomething = 1
		elseif (lev == 0)
		    let tagLists[lev][i]["typeIndex"] = worstIdx
		endif
		let i -= 1
	    endwhile
	    " If no acceptable tags remains at this level, no point going on.
	    if (!exists("tagLists[lev][0]"))
		let done = 1
		break
	    endif
	    if (!removedSomething)
		" Nothing was removed.  No point checking lower levels as
		" nothing will change.
		break
	    endif
	    let lev -= 1
	endwhile
	call DebugTagLists(" After removing bad tags:", tagLists, debug)
	let lev = 0
	while (lev <= level)
	    if (!exists("tagLists[lev][1]"))
		" Only one tag remaining at this level.  Can't possibly refine
		" this any further, so quit now.
		let done = 1
		break
	    endif
	    let lev += 1
	endwhile
	if (done)
	    break   " Do before level is incremented
	endif
	let level += 1
    endwhile
    let tags = tagLists[0]
    if (exists("tags[1]"))
	" We still have more than one tag.  Sort them so that the tag whose
	" class matches types at level 1 earlier come first ("typeIndex").
	" Also, if there is both a constructor and a class, try to choose the
	" most appropriate one first.  The constructor is only appropriate if
	" the word under the cursor is a function call, which means either a
	" "(" will follow, or "new" is before ("nice").
	" Also sort based on the tag's filename matching more of the current
	" file ("fileMatchLen").
	let isFunction = 0
	call setpos(".", origWordPos)
	let line = getline(".")
	let col = col(".") - 1
	if (gotOpWord && match(line, '(', col + 1))
	    let isFunction = 1
	    call search('(', 'W')
	else
	    normal w
	endif
	if (numArgs >= 0)
	    let isFunction = 1
	elseif (CursorChar() == '(')
	    let isFunction = 1
	    " Grab text between (..) and count args.
	    let startPos = getpos(".")
	    normal %
	    let endPos = getpos(".")
	    if (CursorCmp(startPos, endPos) != 0)
		let numArgs = CountArgs(GetText(startPos, endPos))["max"]
	    endif
	else
	    normal b
	    call StepBackNonComment()
	    let line = getline(".")
	    let col = col(".") - 1
	    if (strpart(line, col - 2, 3) == "new" &&
		\ (col - 2 == 0 || line[col - 3] !~ '\w'))
		let isFunction = 1
	    endif
	endif
	if (debug)
	    if (isFunction)
		echo "Function call with " . numArgs . " args"
	    else
		echo "Class name, not function call"
	    endif
	endif
	if (numArgs >= 0)
	    call AddNumArgsFields(tags)
	    for tag in tags
		if (numArgs < tag["minArgs"])	" Too few args
		    let tag["argError"] = tag["minArgs"] - numArgs
		elseif (numArgs > tag["maxArgs"]) " Too many args
		    " Better to have too few args than too many.  It seems
		    " sometimes default args aren't shown as such in tags.
		    let tag["argError"] = numArgs - tag["maxArgs"] + 100
		else
		    let tag["argError"] = 0
		endif
	    endfor
	endif
	let file = resolve(expand("%:p"))
	for tag in tags
	    if ((tag["kind"] == "f") == isFunction)
		let tag["nice"] = 1
	    endif
	    let file2 = fnamemodify(resolve(tag["filename"]), ':p')
	    let len = 0
	    while (file[len] != "" && file[len] == file2[len])
		let len += 1
	    endwhile
	    " Sometimes the file paths will match to the same length, even
	    " though one is in a subfolder, so count any extra slashes as
	    " indicating a less likely path too.
	    let i = len
	    while (file2[i] != "")
		if (file2[i] =~ '[\/]')
		    let len -= 10
		endif
		let i += 1
	    endwhile
	    let tag["fileMatchLen"] = len
	endfor
	call sort(tags, "TagClassCmp")
	call DebugTagLists(" Post sort:", tagLists, debug)
	"for tag in tags
	    "if (has_key(tag, "nice"))
		"unlet tag["nice"]
	    "endif
	    "if (has_key(tag, "argError"))
		"unlet tag["argError"]
	    "endif
	    "unlet tag["fileMatchLen"]
	"endfor
    endif
    if (wantDestructor && exists("tags[0]"))
	" If we really wanted the destructor all along, ie cursor was on
	" "delete" before an identifier, then hopefully now we've figured out
	" what type the identifier is.
	let tag = tags[0]
	if (!has_key(tag, "types"))
	    call AddTypeLists(tags, 1)
	    let tag = tags[0]
	endif
	if (has_key(tag, "types"))
	    for class in tag["types"]
		" First try delete operator.  Remove any tags that aren't our
		" type.
		let tags = UniqTagList('operator delete', 0)
		let i = 0
		while (exists("tags[i]"))
		    let tag = tags[i]
		    if (GetTagClass(tag) != class)
			call remove(tags, i)
		    else
			let i += 1
		    endif
		endwhile
	    endfor
	endif
	if (empty(tags))
	    let tags = UniqTagList('\~' . class, 0)
	endif
    elseif (keepBadTags)
	call extend(tags, badTags)
	call DebugTagLists("Bad tags appended:", tagLists, debug)
    endif
    if (debug)
	echo "Final tags list:"
	for tag in tags
	    echo tag
	endfor
    endif
    let &matchpairs = oldMatchpairs
    let &ic = oldIc
    if (exists("&tagfunc"))
	let &tagfunc = oldTagFunc
    endif
    call winrestview(oldWin)
    call extend(a:niceTags, tags)
    return origWord
endfunc

" Return a list of possible types for the identifier under the cursor.
" TODO: This doesn't work very well.
func! GetTypeList(nameOnly)
    let flags = "t"
    if (a:nameOnly)
	flags .= "n"
    endif
    let tags = []
    let id = GetNiceTagList(tags, flags)
    let types = []
    for tag in tags
	if (has_key(tag, "types"))
	    call extend(types, tag["types"])
	endif
    endfor
    call UniqList(types)
    return types
endfunc

" Show possible types for identifier under cursor.
" TODO: This doesn't work very well.
" Eg something like "static type blah" finds type as "static".
func! ShowType()
    let types = GetTypeList(0)
    if (!exists("types[0]"))
	call Error("Couldn't find type")
	return
    endif
    for type in types
	let str = 'Type'
	let bases = GetBaseClasses(type, 0, 0, "", 0)
	for base in bases
	    let str .= ': ' . base . ' '
	endfor
	echo str
    endfor
endfunc

" Use context to tag more sensibly, eg when ~ or class name appears before tag.
" 'mode' may be one of:
"   "debug": output diagnostics rather than jumping to tag
"   "goto": jump to the tag
"   "split": split to the tag in a new window
"   "tab": open a new tab for the tag
func! SmartTag(mode)
    " Get identifier under cursor
    let flags = "n"
    if (a:mode == "debug")
	let flags .= "d"
    endif
    let tags = []
    let id = GetNiceTagList(tags, flags)
    if (!exists("tags[0]"))
	call Error("SmartTag: tag not found: " . id)
	return
    endif

    " Just use first tag for now
    let tag = tags[0]
    let tagFile = tags[0]["filename"]
    let tagCmd = tags[0]["cmd"]

    if (a:mode == "split")
	"let oldWrap = &wrap
	"set wrap
	split
	" Need to do the following in the original window
	"let &wrap = oldWrap
    elseif (a:mode == "tab")
	tab split
    elseif (a:mode != "debug" && a:mode != "goto")
	call Error('SmartTag: Unknown mode "' . a:mode . '")
	return
    endif

    if (a:mode == "debug")
	echo len(tags) . ' tags for "' . id . '", class "' .
	    \ GetTagClass(tags[0]) . '", file "' . tagFile . '"'
	echo 'cmd "' . tagCmd . '"'
    elseif (tagFile == "")
	exec 'tag ' . id
    else
	call GoToTag(tag, 'd')
    endif
endfunc

function! SmartTagFunc(pattern, flags)
    if (a:flags =~? 'c')
	" We set wrap in an attempt to avoid a bug in vim where, even though we
	" use winrestview(), the original window ends up scrolling from where
	" it started after ^W^] ^Wq.  The cursor remains on the line it started
	" on, but scrolled to a different line of the window.  See
	" "TODO: Scroll-bug" in TestTags.cpp.  Fix is commented out though
	" since it doesn't seem to work.
	"let oldWrap = &wrap
	"set wrap
	let tags = []
	let id = GetNiceTagList(tags, 'nk')
	"let &wrap = oldWrap
	return tags
    else
	let i = strridx(a:pattern, '::')
	if (i < 0 || len(a:pattern) <= i + 2)
	    return taglist(a:pattern)
	else
	    " Found "::".  Separate the class and tag name.
	    let pattern = strpart(a:pattern, i + 2)
	    let class = strpart(a:pattern, 0, i)
	    let tags = taglist(pattern)
	    let i = 0
	    while (exists("tags[i]"))
		" We could either test for an exact match with the class, or a
		" submatch.  Let's allow submatches, as with the tag name
		" itself.  So ":tag B::mA" will find ClassB::mA.
		"if (GetTagClass(tags[i]) != class)
		if (match(GetTagClass(tags[i]), class) < 0)
		    call remove(tags, i)
		else
		    let i += 1
		endif
	    endwhile
	    return tags
	endif
    endif
endfunc

let &cpo = s:oldCpo
