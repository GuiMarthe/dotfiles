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

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END
