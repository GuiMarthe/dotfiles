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
	Plugin 'rust-lang/rust.vim'
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

" Plugins options

let g:jedi#auto_initialization = 0

" Better copy & paste
" " When you want to paste large blocks of code into vim, press F2 before you
" " paste. At the bottom you should see ``-- INSERT (paste) --``.

set pastetoggle=<F2>
set clipboard=unnamed

" Mouse and backspace
set mouse=a  " on OSX press ALT and click
set bs=2     " make backspace behave like normal again

" Bind nohl
" " Removes highlight of your last search
" " ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
noremap <C-n> :nohl<CR>
"vnoremap <C-n> :nohl<CR>
"inoremap <C-n> :nohl<CR>

" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" " it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","

" bind Ctrl+<movement> keys to move around the windows, instead of using
" Ctrl+w + <movement>
" " Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" map sort function to a key
vnoremap <Leader>s :sort<CR>

" easier moving of code blocks
" " Try to go into visual mode (v), thenselect several lines of code here and
" " then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" Color scheme
" " mkdir -p ~/.vim/colors && cd ~/.vim/colors
" " wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
"color wombat256mod

" Enable syntax highlighting
" " You need to reload this file for the change to apply
filetype off
filetype plugin indent on
syntax on

" easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" Useful settings
set history=700
set undolevels=700

"" Vim power line

set rtp+=/home/$USER/anaconda3/lib/python3.6/site-packages/powerline/bindings/vim/

set laststatus=2

" set 'updatetime' to 15 seconds when in insert mode
au InsertEnter * let updaterestore=&updatetime | set updatetime=1500
au InsertLeave * let &updatetime=updaterestore

" Stuff from this presentation
" https://youtu.be/XA2WjJbmmoM
" FINDING FILES:
"
" " Search down into subfolders
" " Provides tab-completion for all file-related tasks
set path+=**
"
" " Display all matching files when we tab complete
set wildmenu
"
" " NOW WE CAN:
" " - Hit tab to :find by partial match
" " - Use * to make it fuzzy
"
" " THINGS TO CONSIDER:
" " - :b lets you autocomplete any open buffer

au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=markdown

" Nice little way to save and save+exit
map Z :w! <CR>
map ZX :wq <CR>


" Navigating with guides
	inoremap <tab><tab> <esc>/<++><enter>"_c4l
	vnoremap <tab><tab> <esc>/<++><enter>"_c4l
	map <tab><tab> <esc>/<++><enter>"_c4l
	inoremap ;gui <++>
	nnoremap ;gui a<++><esc>


