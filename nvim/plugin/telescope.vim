
"""""""""""""""""""""""""""""""""""""""
" TELESCOPE
"""""""""""""""""""""""""""""""""""""""
nnoremap <leader>fw <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>n <cmd>lua require('telescope.builtin').buffers()<CR>
