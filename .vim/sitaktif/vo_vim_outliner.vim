" Tweaks for Vim Outliner
hi OL5 guifg=DarkCyan	ctermfg=DarkCyan
hi OL6 guifg=DarkGray	ctermfg=DarkGray

syntax match SitaComment /\*\w\+\*/
highlight SitaComment gui=bold term=bold cterm=bold

syntax keyword SitaNote NOTE
highlight SitaNote gui=underline term=underline ctermfg=DarkGray

syntax keyword SitaTodo TODO
highlight SitaTodo guibg=DarkBlue term=underline ctermbg=DarkBlue

syntax keyword SitaXxx XXX
highlight SitaXxx guibg=Red term=underline ctermbg=Red


