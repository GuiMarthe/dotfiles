"highlight Normal ctermfg=grey ctermbg=darkblue
" echo 'loading python config from ftplugin'
let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 0
let g:jedi#force_py_version = 3
setlocal encoding=utf-8

setlocal tabstop=4       " The width of a TAB is set to 4.
                         " Still it is a \t. It is just that
                         " Vim will interpret it to be having
                         " a width of 4.

setlocal shiftwidth=4    " Indents will have a width of 4

setlocal softtabstop=4   " Sets the number of columns for a TAB

setlocal expandtab       " Expand TABs to spaces

" za for code folding
	setlocal foldmethod=indent
	setlocal foldlevel=99

" color trailing whitespaces 
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$/

" 80 characters colored column
	setlocal cc=120
	hi ColorColumn ctermbg=lightgrey guibg=lightgrey

"""" code snippets

" function defninition

inoremap ;def <Esc>:-1read /home/$USER/.vim/snippets/python_snippets/function_snippet.py<CR>jVk
" class defninition
inoremap ;class <Esc>:-1read /home/$USER/.vim/snippets/python_snippets/class_snippet.py<CR>
inoremap ;main <Esc>:-1read /home/$USER/.vim/snippets/python_snippets/script_snippet.py<CR>
inoremap ;tran <Esc>:-1read /home/$USER/.vim/snippets/python_snippets/transformer_snippet.py<CR>
inoremap ;pr print(<++>)<Esc>Fp

