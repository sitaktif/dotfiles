fun! s:DetectBash()
    if getline(1) == '#!/bin/bash'
        set ft=sh
    endif
endfun

autocmd BufNewFile,BufRead * call s:DetectBash()
