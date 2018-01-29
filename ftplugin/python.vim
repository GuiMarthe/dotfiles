"highlight Normal ctermfg=grey ctermbg=darkblue
echo 'loading python config from ftplugin'
let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 0
let g:jedi#force_py_version = 3
set encoding=utf-8


set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces

" za for code folding
	set foldmethod=indent
	set foldlevel=99

" color trailing whitespaces 
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$/

" 80 characters colored column
	set cc=80
	hi ColorColumn ctermbg=lightgrey guibg=lightgrey

" code snippets

" function defninition

inoremap ;func <Esc>:-1read /home/$USER/.vim/snippets/python_snippets/function_snippet.py<CR>Vj
inoremap ;class <Esc>:-1read /home/$USER/.vim/snippets/python_snippets/class_snippet.py<CR>

