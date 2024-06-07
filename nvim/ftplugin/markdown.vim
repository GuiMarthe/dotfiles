
hi ColorColumn ctermbg=black guibg=black

function! ProseMode()
  call goyo#execute(0, [])
  set  noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  set bg=light
endfunction

command! ProseMode call ProseMode()
" Simple mapping for prose mode

" Simple toggle for spelling
map <F6> :setlocal spell! spelllang=en_us,pt_br,pt<CR>

" Use the zg command to its good words dictionary.
" zw will add a word to the wrong words dictionary.
" z= will offer a completion list. Press a number to correcr the word
" [s will go to the next wrong word
" ]s will go back one wrong word

" a few commands so we can have automatic stuff
	autocmd Filetype markdown,rmd inoremap ;1 #<Space><Enter><++><Esc>kA
	autocmd Filetype markdown,rmd inoremap ;2 ##<Space><Enter><++><Esc>kA
	autocmd Filetype markdown,rmd inoremap ;3 ###<Space><Enter><++><Esc>kA
	autocmd Filetype markdown,rmd inoremap ;i ![](<++>)<++><Esc>F[a
	autocmd Filetype markdown,rmd inoremap ;a [](<++>)<++><Esc>F[a
	autocmd Filetype markdown,rmd inoremap ;b ****<++><Esc>F*hi
	autocmd Filetype markdown,rmd inoremap ;s ~~~~<++><Esc>F~hi
	autocmd Filetype markdown,rmd inoremap ;e **<++><Esc>F*i
" easier formatting of paragraphs
	autocmd Filetype markdown,rmd vmap Q gq
	autocmd Filetype markdown,rmd nmap Q gqap
