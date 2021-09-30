" Nice little way to save and save+exit
map Z :w! <CR>: echo "Saved"<CR>
map ZX :wq <CR>

" Better code indentation
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

"Line movements
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"""""""""""""""""""""""""""""""""""""""
" LEADER COMMANDS
"""""""""""""""""""""""""""""""""""""""
" Rebind <Leader> key
" easier moving between tabs
map <Leader><Space> <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
" go to last edited file
nnoremap <Leader><Leader> <c-^>
" greatest remap ever
vnoremap <leader>p "_dP

" next greatest remap ever : asbjornHaland
nnoremap <leader>y "*y
vnoremap <leader>y "*y
nnoremap <leader>Y gg"*yG

nnoremap <leader>d "_d
vnoremap <leader>d "_d

"""""""""""""""""""""""""""""""""""""""
" NAVIGATING WITH GUIDES
"""""""""""""""""""""""""""""""""""""""
inoremap <tab><tab> <esc>/<enter>"_c4l
vnoremap <tab><tab> <esc>/<++><enter>"_c4l
map <tab><tab> <esc>/<++><enter>"_c4l
inoremap <leader>gui <++>
nnoremap <leader>gui a<++><esc>

"""""""""""""""""""""""""""""""""""""""
" TOGGLE NUMBERING
"""""""""""""""""""""""""""""""""""""""
nn <F3> :call ToggleNumber()<CR>
fun! ToggleNumber()
    if exists('+relativenumber')
        :exec &nu==&rnu? "setl nu!" : "setl rnu!"
    else
        setl nu!
    endif
endf

"""""""""""""""""""""""""""""""""""""""
" NETRW INTERACTION
"""""""""""""""""""""""""""""""""""""""
nnoremap <C-e> :Lex <CR>
nnoremap <leader>re :let @/=expand("%:t") <Bar> execute ':Lex' expand("%:h") <CR>


"""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
"""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>s :call RenameFile()<cr>

"""""""""""""""""""""""""""""""""""""""
" INSERT TIME
"""""""""""""""""""""""""""""""""""""""
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
inoremap <leader>time <Esc>:InsertTime<cr>
inoremap <leader>date <Esc>a<c-r>=strftime('%F')<cr>
