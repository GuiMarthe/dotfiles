
setlocal encoding=utf-8
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab

" za for code folding
setlocal foldmethod=indent
setlocal foldlevel=99

" color trailing whitespaces 
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" 80 characters colored column
setlocal cc=88
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

let g:black_linelength = 88

map <leader>r :Black<cr>

"""" code snippets

inoremap <Leader>def <Esc>:-1read $HOME/.config/nvim/snippets/python_snippets/function_snippet.py<CR>jVk
inoremap <Leader>class <Esc>:-1read $HOME/.config/nvim/snippets/python_snippets/class_snippet.py<CR>
inoremap <Leader>main <Esc>:-1read $HOME/.config/nvim/snippets/python_snippets/script_snippet.py<CR>
inoremap <Leader>tran <Esc>:-1read $HOME/.config/nvim/snippets/python_snippets/transformer_snippet.py<CR>
inoremap <Leader>pr print(<++>)<Esc>Fp

inoremap <Leader>l import ipdb;ipdb.set_trace();
noremap <Leader>l Oimport ipdb;ipdb.set_trace();<Esc>

command QfFk8 :cexpr system('ruff .')
