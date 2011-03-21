" Vim cpp plugin for Amadeus
" Last Change:	2011 Feb 04
" Maintainer:	Romain Chossart <romainchossart@gmail.com>
" License:	This plugin is the property of Amadeus Services Ltd.

" Todo_list:
" [ ] Some beta testing

"" Summary:
" This filetype plugin is for cpp files that are in CM pwe folders. It:
" - Generates tags automatically (you have to generate tags in a non)
" - Does the config for tag jumps (CTRL-], and CTRL-T to rewind) *including* macros.
" - Autocompletion with CTRL-x_CTRL-o (a bit limited though...)
" - Adds a few mappings:
"   * \eh, \ec, \ei	Go to .hpp, .cpp or .i corresponding file.
"   * <f12>		Refresh tags

"" Prerequisites:
" - having put ~/.vim/amadeus.vim in your home


"" FAQ:
" Q1. Your plugin overrides one of my mappings ! (<F12> maybe...)
" A1. Add  map <unique> <leader>at <Plug>AMA_CPPMakeCppTags  to you vimrc for
" example. When a mapping to a functionality already exists, the script does
" not add any.
" Q2. I have got a "Warning: Your team has not been found in the list."
" message at startup
" A2. You have to complete the list of packages you want the tags for. Don't
" be greedy and try to put only packages you need.


" Note: Use "za" keystrokes to alternate folding below.

if ! exists('g:AMA_CM_TEAM_PACKAGES')
    " Display error message only once otherwise it will be annoying.
    if !exists("g:loaded_amadeus_plugin")
	echohl ErrorMsg
	echomsg "FATAL: amadeus.vim not loaded. Make sure you have amadeus.vim in ~/.vim/plugin/ dir."
	echohl None
    endif
    finish
endif

if exists("loaded_cpp_amadeus")
    finish
endif
let loaded_cpp_amadeus = 1


" Additional stuff for macro-defined vars
let s:_ctags_m_a  = '--regex-c++=''/^\s*DCS_DEF_(PROTECTED)?MEMBER(_GET)?(_SET)?\([^,]*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*/\4/d,definition/'' '
let s:_ctags_m_a .= '--regex-c++=''/^\s*DCS_DEF_(PROTECTED)?MEMBER_GET\([^,]*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*/\2/d,definition/'' '
let s:_ctags_m_a .= '--regex-c++=''/^\s*DCS_DEF_(PROTECTED)?MEMBER_GET\([^,]*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*/get\3/d,definition/'' '
let s:_ctags_m_a .= '--regex-c++=''/^\s*DCS_DEF_(PROTECTED)?MEMBER_SET\([^,]*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*/\2/d,definition/'' '
let s:_ctags_m_a .= '--regex-c++=''/^\s*DCS_DEF_(PROTECTED)?MEMBER_SET\([^,]*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*/set\3/d,definition/'' '
let s:_ctags_m_a .= '--regex-c++=''/^\s*DCS_DEF_(PROTECTED)?MEMBER\([^,]*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*/get\3/d,definition/'' '
let s:_ctags_m_a .= '--regex-c++=''/^\s*DCS_DEF_(PROTECTED)?MEMBER\([^,]*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*/set\3/d,definition/'' '
let s:_ctags_m_a .= '--regex-c++=''/^\s*DCS_DEF_(PROTECTED)?MEMBER\([^,]*,\s*(\w+)\s*,\s*(\w+)\s*\)\s*/for\3/d,definition/'' '

let s:_ctags_args = '--language-force=c++ --c++-kinds=+p --fields=+iaS --extra=+q '.s:_ctags_m_a

" Takes a package name and returns the list of package names that are related
" in format like {pk1,pk2} that is useable by zsh/bash.
"function! s:AMA_CPPGetGlobFromTeam(team, package)"{{{
"    if exists('g:AMA_CM_TEAM_PACKAGES["'.a:team.'"]')
"        " Try to find the team in the dedicated dictionary
"        return "{".join(g:AMA_CM_TEAM_PACKAGES[a:team], ',').",com}"
"    else
"	echohl WarningMsg
"	echomsg "Warning: Your team has not been found in the list."
"	echomsg "Please complete g:AMA_CM_TEAM_PACKAGES variable in ~/.vim/plugin/amadeus.vim"
"        " Finally, if not found, just return the package name and com
"        return "{".a:package.",com}"
"    endif
"endfunction"}}}

function! AMA_CPPGetPWETOP(path)"{{{
    " Set: path. Errors: symlink
    "if "" == matchstr(a:path, '^/data/vtmp/shadow') " If it's not a 'mkvdir'
	"if "" != matchstr(a:path, '^\(/vtmp/\|/data/\)') " and we are in a symlink
	    "echo "In symlinked package."
	    "return ""
	"endif
    "endif

    " Set: pwetop
    let l:pwetop = matchstr(a:path, '^\zs.\{-}/pwe/.\{-}\ze/ng...\(pub\)\=/src/')
    if l:pwetop == ""
	let l:pwetop = matchstr(a:path, '^\zs.\{-}/pwe/.\{-}\ze/')
	echo 
    endif
    " Error: Could not set pwetop
    if l:pwetop == ""
	echohl WarningMsg|echomsg "FATAL: Cannot determine current pwe top. Assuming cpp file is not in CM."|echohl None
        return ""
    endif
    return l:pwetop
endfunction"}}}

" Make / Update CPP tags.
" arg1: force_ctags (default: 1)
function! AMA_CPPMakeCppTags(...) abort"{{{
    if !exists('a:1')
        " Defaults to 0 (true), ie only if tags don't exist.
	" Updating automatically every 24h would be harrassing since we have
	" one tag file per pwe folder. You can force refresh with <f12>.
        let l:force_tags = 0
    else
        let l:force_tags = a:1
    endif
    if !exists('a:2')
        " Defaults to 0 (false), ie only every 24h (it is ok because we have
	" only  one tag file for all projects).
        let l:force_mdw_tags = 0
    else
        let l:force_mdw_tags = a:2
    endif

    let l:path = expand('`pwd`').expand('%')
    let l:pwetop=AMA_CPPGetPWETOP(l:path)

    
    " Set: package. Error: no package found
    "let l:package = matchstr(l:path, l:pwetop.'/ng\zs\(...\(pub\)\=\)\ze/')
    "if l:package == ""
    "    echohl ErrorMsg|echomsg "FATAL: Cannot determine current DCS package."|echohl None
    "    return
    "endif
    "" (file-)local change directory to 'PWETOP/ngXXX/src/'
    "let l:srctop = l:pwetop."/ng".l:package
    "echomsg "INFO: Changing vim local directory to ".l:srctop."/src"
    "exec "lcd ".l:srctop."/src"

    " Set: A unique id for the current project
    let l:pwe_id = substitute(matchstr(l:pwetop, '.*/pwe/\zs.*'), '/', '__', 'g')
    let l:is_tags_updated = 0


    """""""""""""""""""""""""""""""""
    " Generate the "user's team tags""{{{
    "
    let l:tagfile = "/tmp/cpp_tags_".expand("$USER")."_".l:pwe_id
    let l:ftime = getftime(l:tagfile)
    let l:timespan = localtime() - l:ftime

    " (before we updated every 24h.. maybe a bit too much when you work on a
    " lot of packages. To see. I keep it in comment just in case.)
    "if l:ftime == -1 || str2nr(l:timespan) > (3600 * 24) || l:force_tags == 1
    if l:ftime == -1 || l:force_tags == 1
        if l:ftime == -1
            echo "No tag file yet. Creating them."
        else
            call system("rm ".l:tagfile)
            echomsg "Refreshing tags."
        endif
        " Find the right packages to tag ; UPDATE: we take all packages.
        "let l:team_pkgs_glob = s:AMA_CPPGetGlobFromTeam(g:AMA_USER_TEAM, l:package)
        "let l:absolute_pkgs_glob = l:pwetop."/ng".l:team_pkgs_glob

        let l:find_cmd = "find ".l:pwetop."/ng???{,pub} -follow"
        let l:find_cmd .= " \\( -path '*/CVS' -o -path '*/lib' -o -path '*/obj' -o -name 'test.*' \\) -prune"
        let l:find_cmd .= " -o \\( -name '*.i' -o -name '*.hpp' \\) -print0"
        "let l:find_cmd .= " 2> /dev/null |wc"
        " The -a[ppend] is important: xargs may split arguments into several "ctags"
        let l:ctags_cmd = "ctags -a -f ".l:tagfile." ".s:_ctags_args

        " Execute the ctags command
        echomsg "Updating non-middleware tags... (usually takes less than a minute)"
        call system(l:find_cmd."|xargs -0 --max-chars=100000 ".l:ctags_cmd)
	let l:is_tags_updated = 1

    endif"}}}


    """""""""""""""""""""""""""""""""
    " Generate the "middleware tags""{{{
    "
    let l:tagfile_mdw = "/tmp/cpp_mdwtags_".expand("$USER")
    let l:ftime_mdw = getftime(l:tagfile_mdw)
    let l:timespan_mdw = localtime() - l:ftime_mdw

    if getftime(l:pwetop."/.build") == -1
	echohl WarningMsg
        echomsg "Project has not been built yet. Please do that to get more tags."
	echohl None
    elseif l:ftime_mdw == -1 || str2nr(l:timespan_mdw) > (3600 * 24) || l:force_mdw_tags == 1
        if l:ftime_mdw == -1
            echomsg "No middleware tags yet. Creating them."
        else
	    if str2nr(l:timespan_mdw) > (3600 * 24)
		echomsg "Middleware tags have not been updated for 24h."
	    else
		echomsg "Forcing middleware tags update."
	    endif
            call system("rm ".l:tagfile_mdw)
        endif

	let l:find_folders = l:pwetop."/.build/amd_root/mdw "
	let l:find_folders .= l:pwetop."/.build/amd_root/ngd_???/default/."
        let l:find_cmd = "find ".l:find_folders." "
        let l:find_cmd .= "-wholename '*/lib' -prune -o "
	let l:find_cmd .= "-maxdepth 5 -name '*.hpp' "
        let l:find_cmd .= "-wholename '*/include/*' -print0 2> /dev/null"
        " The -a is important: xargs may split arguments into several "ctags"
        let l:ctags_cmd = "ctags -a -f ".l:tagfile_mdw." ".s:_ctags_args

	echohl l:find_cmd

        " Execute the ctags command
        echomsg "Updating middleware tags... (usually takes several seconds)"
        call system(l:find_cmd."|xargs -0 --max-chars=100000 ".l:ctags_cmd)
	let l:is_tags_updated = 1

    endif"}}}

    call AMA_CPPSetCppTags()

    redraw!

    echohl Question
    if l:is_tags_updated == 1
	echomsg "Tags have been updated."
    else
	echomsg "Tags are already up to date. Enter  :call AMA_CPPMakeCppTags(1,1)  to force update."
    endif
    echohl None

endfunction"}}}

function! AMA_CPPSetCppTags()"{{{
    let l:path = expand('`pwd`').expand('%')
    let l:pwetop=AMA_CPPGetPWETOP(l:path)
    let l:pwe_id = substitute(matchstr(l:pwetop, '.*/pwe/\zs.*'), '/', '__', 'g')

    let l:tagfile = "/tmp/cpp_tags_".expand("$USER")."_".l:pwe_id
    if  !(filereadable(l:tagfile))
	echohl ErrorMsg | echomsg "Warning: File ".l:tagfile." is not readable." | echohl None
    elseif stridx(&tags, l:tagfile) == -1
	exec 'set tags+='.l:tagfile
    endif

    let l:tagfile_mdw = "/tmp/cpp_mdwtags_".expand("$USER")
    if  !(filereadable(l:tagfile_mdw))
	echohl ErrorMsg | echomsg "Warning: File ".l:tagfile_mdw." is not readable." | echohl None
    elseif stridx(&tags, l:tagfile_mdw) == -1
	exec 'set tags+='.l:tagfile_mdw
    endif

endfunction"}}}

" Cleans old cpp tags to avoid cluttering /tmp
function! AMA_CPPCleanCppTags(force_delete)"{{{
    let l:tagfile = glob("/tmp/cpp_tags_".expand("$USER")."_*")
    for i in split(l:tagfile, "\n")
	let l:timespan = localtime() - getftime(i)
	if a:force_delete == 1
	    echo "Deleting `".i."` tag file: force indicator set."
	    call system("rm ".i)
	elseif str2nr(l:timespan) > (3600 * 24 * 7)
	    echo "Deleting `".i."` tag file: it was older than a week."
	    call system("rm ".i)
	else
	    echo "NOT deleting `".i."` tag file: it was NOT older than a week."
	endif
    endfor
endfunction"}}}



"""""""""""""""""""""""""""""
" End of functions definition


" Set tags (locally) at startup for each CPP file
autocmd FileType cpp :call AMA_CPPSetCppTags()

"" Mappings

" Refresh tags (override <F12> by adding to your vimrc:
" map <buffer> <unique> OTHER_MAPPING <Plug>AMA_CPPMakeCppTags
if !hasmapto('<Plug>AMA_CPPMakeCppTags')
    silent! map <buffer> <unique> <F12> <Plug>AMA_CPPMakeCppTags
endif
noremap <Plug>AMA_CPPMakeCppTags :call AMA_CPPMakeCppTags(1,0)<cr>

" Switch from .cpp to .hpp or .i
map <leader>ei :e %:r.i<cr>
map <leader>eh :e %:r.hpp<cr>
map <leader>ec :e %:r.cpp<cr>


"" Autocommands

" Delete trailing whitespaces on write/save
autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))


"""""""""""""""""""""""""""
"" Main (executed ONCE only)

" Do a bit of cleanup
call AMA_CPPCleanCppTags(0)

" Try to make the tags at vim opening
call AMA_CPPMakeCppTags(0, 0)

