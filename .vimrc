set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	Plugin 'VundleVim/Vundle.vim'
	Plugin 'davidhalter/jedi-vim'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-surround'
	Plugin 'tpope/vim-repeat'
	Plugin 'tpope/vim-commentary'
	Plugin 'junegunn/goyo.vim'
	Plugin 'michaeljsmith/vim-indent-object'
	Plugin 'vim-scripts/ReplaceWithRegister'
	Plugin 'alfredodeza/jacinto.vim'
	Plugin 'mileszs/ack.vim'
	Plugin 'mattn/vim-sqlfmt'
	Plugin 'gaving/vim-textobj-argument'
	Plugin 'Townk/vim-autoclose'
	Plugin 'ekalinin/Dockerfile.vim'
	Plugin 'vimwiki/vimwiki'
	Plugin 'arcticicestudio/nord-vim'
	Plugin 'itchyny/lightline.vim'
	Plugin 'psf/black'
	Plugin 'Vimjas/vim-python-pep8-indent'
    Plugin 'junegunn/fzf.vim'
call vundle#end()            " required
filetype plugin indent on    " required
" Provides tab-completion for all file-related tasks
set path+=**
" Display all matching files when we tab complete
set wildmenu
" Split the correct way
set splitbelow
set splitright

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,full
" netrw 
let g:netrw_liststyle = 3
let g:netrw_preview = 1
let g:netrw_winsize = 30
let g:netrw_banner = 0
" Plugins options
let g:jedi#auto_initialization = 0
"Paste mode settings
set pastetoggle=<F2>
set clipboard=unnamedplus
" Mouse and backspace
set mouse=a  " on OSX press ALT and click
set bs=2     " make backspace behave like normal again
" Rebind <Leader> key
let mapleader = ","
" Better window moving
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
" easier moving between tabs
map <Leader><Space> <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
" go to last edited file
nnoremap <Leader><Leader> <c-^>
" yank to system keyboard
map <leader>y "*y
" Better code indentation
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" color scheme
set t_Co=256
colorscheme nord
hi Comment guifg=#5C6370 ctermfg=59
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

" Enable syntax highlighting
" You need to reload this file for the change to apply
filetype off
filetype plugin indent on
syntax on

" Useful settings
set history=700
set undolevels=700
set nu
set rnu
set cursorline
set laststatus=2

au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown

" Nice little way to save and save+exit
map Z :w! <CR>
map ZX :wq <CR>

"""""""""""""""""""""""""""""""""""""""
" NAVIGATING WITH GUIDES
"""""""""""""""""""""""""""""""""""""""
inoremap <tab><tab> <esc>/<++><enter>"_c4l
vnoremap <tab><tab> <esc>/<++><enter>"_c4l
map <tab><tab> <esc>/<++><enter>"_c4l
inoremap ;gui <++>
nnoremap ;gui a<++><esc>

"""""""""""""""""""""""""""""""""""""""
" INSERT TIME
"""""""""""""""""""""""""""""""""""""""
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
inoremap ;time <Esc>:InsertTime<cr>
inoremap ;date <Esc>a<c-r>=strftime('%F')<cr>

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
map <leader>S :call RenameFile()<cr>

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
" VIMWIKI CONFIG
"""""""""""""""""""""""""""""""""""""""

let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown':'markdown'}

let g:vimwiki_list = [{'path': '~/gui_kb/',  'syntax':'markdown', 'ext': '.md'}]


"""""""""""""""""""""""""""""""""""""""
" BLACK CONFIG
"""""""""""""""""""""""""""""""""""""""
let g:black_linelength = 88
