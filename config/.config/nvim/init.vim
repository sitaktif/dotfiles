set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
source ~/.vim/vimrc

if exists("g:neovide")
    " Cmd-C / Cmd-V
    vmap <D-c> "+y
    nmap <D-v> "+P
    vmap <D-v> "+P
    cmap <D-v> <C-R>+
    imap <D-v> <C-o>"+P

    " Cmd+ / Cmd-
    let g:neovide_scale_factor=1.0
    function! ChangeScaleFactor(delta)
        let g:neovide_scale_factor = g:neovide_scale_factor * a:delta
    endfunction
    function! ResetScaleFactor()
        let g:neovide_scale_factor = 1.0
    endfunction
    nnoremap <expr><D-=> ChangeScaleFactor(1.1)
    nnoremap <expr><D--> ChangeScaleFactor(1/1.1)
    nnoremap <expr><D-0> ResetScaleFactor()

    nnoremap <D-a> G$vgg0

    " Tabs
    nmap <D-t> :tabnew<CR>
    imap <D-t> <C-o>:tabnew<CR>
    nmap <D-w> :tabclose<CR>
    imap <D-w> <C-o>:tabclose<CR>

    " Disable animations
    let g:neovide_position_animation_length = 1
    let g:neovide_cursor_animation_length = 0.02
    let g:neovide_cursor_trail_size = 0
    let g:neovide_cursor_animate_in_insert_mode = v:true
    let g:neovide_cursor_animate_command_line = v:true
    let g:neovide_scroll_animation_far_lines = 1
    let g:neovide_scroll_animation_length = 0.02
end

" -- Allow clipboard copy paste in neovim
" vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
" vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
" vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
" vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
