" Django (ca fout la merde, TODO: régler ca)
"autocmd FileType htmldjango imap {% {%  %}<esc>2hi
"autocmd FileType htmldjango imap <leader>b <esc>:s/{% block \(.*\) %}/&\r{% endblock \1 %}<cr>:noh<cr>O
"autocmd FileType htmldjango imap <leader>e <esc>:s/{% \([a-zA-Z]\+\) \(.*\) %}/&\r{% end\1 \2 %}<cr>:noh<cr>O


