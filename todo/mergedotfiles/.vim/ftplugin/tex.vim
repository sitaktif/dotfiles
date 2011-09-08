" set to compile pdfs multiple times if necessary (mmh, not sure..)
let g:Tex_MultipleCompileFormats = 'dvi,pdf'

"sets the default output to pdf
let g:Tex_DefaultTargetFormat='pdf'

" sets the execution string that will be used to compile the tex source
let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode -file-line-error-style $*'

" sets the -annoying- warnings to ignore
let g:Tex_IgnoredWarnings =
	\'Underfull'."\n".
	\'Overfull'."\n".
	\'Font Warning'."\n".
	\'specifier changed to'."\n".
	\'You have requested'."\n".
	\'Float too large'."\n".
	\'Missing number, treated as zero.'."\n".
	\'There were undefined references'."\n".
	\'Citation %.%# undefined'

" the 'ignore level' of the 'efm'. A value of 4 says that the first 4 kinds of
" warnings in the list above will be ignored. Use the command TCLevel to set a
" level dynamically.
let g:Tex_IgnoreLevel = 6

" sets the execution string that will be used to view the pdf output
if has('macunix')
let g:Tex_ViewRuleComplete_pdf='open $*.pdf'
else
let g:Tex_ViewRuleComplete_pdf='evince $*.pdf &'
endif

" Fixes the "é" problem
imap <buffer> <leader>it <Plug>Tex_InsertItemOnThisLine
" Fixes other accents problem
imap <C-b> <Plug>Tex_MathBF
imap <C-c> <Plug>Tex_MathCal
imap <C-l> <Plug>Tex_LeftRight

" Puts items with "\it" for /begin{list}
let g:Tex_ItemStyle_list = '\item '

""""""""""
"PERSONNAL
""""""""""

"" General bindings

" Puts marks %%{{{ and %%}}} ([H]igh and [L]ow)
iabbr LFH %%{{{
iabbr LFL %%}}}

" Converts \'{e} into é, etc..
map <leader>tc :s/\\'{e}/é/ge<bar>s/\\`{e}/è/ge<bar>s/\\[ˆ^]{e}/ê/ge<bar>s/\\`{a}/à/ge<bar>s/\\[ˆ^]{o}/ô/ge<bar>s/\\[ˆ^]{i}/î/ge<cr>

" Cleans the intermediate compilation files
if g:Tex_DefaultTargetFormat == 'pdf'
	map <leader>lc :silent !rm *.aux *.dvi *.log<cr>
else " Keep dvi
	map <leader>lc :silent !rm *.aux *.log<cr>
endif


"" EB3
call IMAP('EAC', "\\EActionLabel{<++>}<++>", 'tex') 


imap ² <c-j>

call IMAP('EFN', "\\footnote{<++>}<++>", 'tex') 
call IMAP('REF', "figure\~\\ref{<+1+>} page\~\\pageref{<+1+>}<++>", 'tex') 


imap → \vd}<left>{<right> 
imap € \equivv}<left>{<right> 

"General : p phi, P psi, t not, a and, z or
imap þ \phi}<left>{<right> 
imap Þ \psi}<left>{<right> 
imap ŧ \negg}<left>{<right> 
imap « \vee}<left>{<right> 
imap æ \land}<left>{<right> 

" LTL : d diamond, o box, c circle(next)
imap ð \dia}<left>{<right> 
imap ø \boxx}<left>{<right> 
imap ¢ \cirr}<left>{<right> 


" --COMPILATION
set grepprg=grep\ -nH\ $*
map <F11> :!bibtex %:t:r<cr>
map <F12> <leader>ll<leader>lv
"map <silent> <c-F12> <leader>ll<leader>lv

set path+=~/.texmf/**

" --BEAMER
call IMAP('BFR', "\\begin{frame}\<CR>\\frametitle{<++>}\<CR>\<CR><++>\<CR>\\end{frame}\<cr><++>", 'tex') 
call IMAP('BBL', "\\begin{block}{<+blocktitle+>}\<CR><++>\<CR>\\end{block}\<CR><++>", 'tex') 
call IMAP('BAB', "\\begin{alertblock}{<+blocktitle+>}\<CR><++>\<CR>\\end{alertblock}\<CR><++>", 'tex') 
call IMAP('BEB', "\\begin{exampleblock}{<+blocktitle+>}\<CR><++>\<CR>\\end{exampleblock}\<CR><++>", 'tex') 
"Parts of frames's succession
imap BN1 <1->
imap BN2 <2->
imap BN3 <3->
imap BN4 <4->
imap BN5 <5->
imap BN6 <6->
imap BN7 <7->
imap BN8 <8->
imap BN9 <9->
