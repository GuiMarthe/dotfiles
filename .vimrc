set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'
	Bundle 'gabrielelana/vim-markdown'
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
	Plugin 'sjl/badwolf'
	Plugin 'mattn/vim-sqlfmt'
	Plugin 'vim-scripts/indentpython.vim'
	Plugin 'gaving/vim-textobj-argument'
	Plugin 'Townk/vim-autoclose'
	Plugin 'prakashdanish/vimport'
	Plugin 'ekalinin/Dockerfile.vim'
	Plugin 'tmhedberg/SimpylFold'
	Plugin 'vimwiki/vimwiki'
	Plugin 'dracula/vim'
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Stuff from this presentation
" https://youtu.be/XA2WjJbmmoM
" FINDING FILES:
"
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
"
" Display all matching files when we tab complete
" set wildmenu
" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy
set wildmenu
"
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

" Better copy & paste
" When you want to paste large blocks of code into vim, press F2 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.

set pastetoggle=<F2>
set clipboard=unnamedplus

" Mouse and backspace
set mouse=a  " on OSX press ALT and click
set bs=2     " make backspace behave like normal again

" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","

" bind Ctrl+<movement> keys to move around the windows, instead of using
" Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" easier moving between tabs
map <Leader><Space> <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" go to last edited file
nnoremap <Leader><Leader> <c-^>

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several time.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
" colorscheme badwolf         " awesome colorscheme
"color wombat256mod
colorscheme dracula
hi Comment guifg=#5C6370 ctermfg=59

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

" Vim power line

set rtp+=/home/$USER/anaconda3/lib/python3.6/site-packages/powerline/bindings/vim/

set laststatus=2

" set 'updatetime' to X seconds when in insert mode
" au InsertEnter * let updaterestore=&updatetime | set updatetime=7000
" au InsertLeave * let &updatetime=updaterestore
" au CursorHoldI * stopinsert


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
inoremap ;date <Esc>a<c-r>=strftime('%F)<cr>

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


