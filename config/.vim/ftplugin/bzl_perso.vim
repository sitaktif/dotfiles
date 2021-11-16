function! Preserve(command)
  let pos = getpos('.')
  execute a:command
  call setpos('.', pos)
endfunction

" if executable('buildifier')
"   autocmd BufWritePre *.bzl :call Preserve('%!buildifier')
"   autocmd BufWritePre *.bazel :call Preserve('%!buildifier')
"   autocmd BufWritePre BUILD :call Preserve('%!buildifier')
"   autocmd BufWritePre WORKSPACE :call Preserve('%!buildifier')
" endif
