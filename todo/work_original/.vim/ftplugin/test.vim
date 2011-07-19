"""let g:AMA_ALL_PKGS = ['acc', 'afw', 'ams', 'apq', 'bld', 'bmt', 'brd', 'bzr', 'cds', 'cfa', 'cmp', 'cmt', 'com', 'cpr', 'crp', 'cry', 'ctp', 'dba', 'ehb', 'etk', 'exq', 'fli', 'fmc', 'fmt', 'hfw', 'hst', 'hub', 'idc', 'inv', 'lst', 'ola', 'onl', 'pag', 'pay', 'pcv', 'prt', 'qdm', 'reg', 'rgd', 'sct', 'sec', 'smt', 'swp', 'syn', 'tci', 'www']
"""
"""
"""let s:AMA_linked_packages = []
"""let s:AMA_linked_packages += [['ams', 'qdm']] " Acceptance
"""let s:AMA_linked_packages += [['smt', 'rgd', 'inv', 'onl','reg']] "Seating

" This function takes a package name 
" and returns the list of package names that
" are related in format like {pk1,pk2} that is
" useable by zsh/bash.
" Subfolder is the regression subfolder. 
"""function! SCNGetRegexFromPkg(pkg_name, subfolder)
"""    let l:path = expand('%:p:h')
"""    let l:pwetop = matchstr(l:path, '\zs.\{-}\ze/ng...rgr/')
"""    let l:package = matchstr(l:path, '/ng\zs\(...\)\zergr/')
"""    let l:retval = ""
"""    for l:v in s:AMA_linked_packages
"""        echo l:v
"""        if index(l:v, a:pkg_name) != -1
"""            l:retval += join(l:v, ",")
"""        endif
"""    endfor
"""    " Finally, if not found, just return the package name
"""    if l:retval == ""
"""	return a:pkg_name
"""    endif
"""    " And now, process the subfolders
"""    if isdirectory(l:pwetop.'ngcomrgr/lib/dev/'.a:subfolder)
"""	l:retval += ','.a:subfolder
"""    elseif s:subfolder == 'HIST'
"""	l:retval += ',hst'
"""    endif
"""    " TODO Cas particulier HIST=>(hst, hfw)
"""    return '{'.l:retval.'}'
"""endfunc


