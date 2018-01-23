set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
Plugin 'junegunn/goyo.vim'
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Bundle 'gabrielelana/vim-markdown'
Plugin 'davidhalter/jedi-vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
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

" Markdown settings
let g:markdown_enable_spell_checking = 0
let g:markdown_include_jekyll_support = 1

" Better copy & paste
" " When you want to paste large blocks of code into vim, press F2 before you
" " paste. At the bottom you should see ``-- INSERT (paste) --``.
"
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

set rtp+=/home/gui/anaconda3/lib/python3.6/site-packages/powerline/bindings/vim/

set laststatus=2

" set 'updatetime' to 15 seconds when in insert mode
au InsertEnter * let updaterestore=&updatetime | set updatetime=15000
au InsertLeave * let &updatetime=updaterestore

" Stuff from this presentation
" https://youtu.be/XA2WjJbmmoM
"
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
function! ProseMode()
  call goyo#execute(0, [])
  set  noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  set bg=light
  " if !has('gui_running')
  "   let g:solarized_termcolors=256
  " endif
  " colors solarized
endfunction

command! ProseMode call ProseMode()
