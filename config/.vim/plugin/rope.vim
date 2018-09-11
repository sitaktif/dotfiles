" Rope AutoComplete
let ropevim_vim_completion = 1
let ropevim_extended_complete = 1
let g:ropevim_autoimport_modules = ["os.*","traceback","django.*"]

imap <c-space> <C-R>=RopeCodeAssistInsertMode()<CR>
