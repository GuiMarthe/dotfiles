
call plug#begin('~/.vim/plugged')
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-commentary'
	Plug 'vim-scripts/ReplaceWithRegister'
	Plug 'ekalinin/Dockerfile.vim', {'for': 'dockerfile'}
	Plug 'psf/black', {'for': 'python'}
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins', 'for':'python'}
    Plug 'b4b4r07/vim-sqlfmt', {'for': 'sql'}
    Plug 'jackc/sqlfmt', {'for': 'sql'}
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'nvim-treesitter/playground'
    Plug 'ayu-theme/ayu-vim'
    Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
    Plug 'slarwise/vim-tmux-send'
    Plug 'ThePrimeagen/harpoon'
call plug#end()

syntax on
filetype plugin indent on

let mapleader = ","

"python env configurations
let g:loaded_python_provider = 0 "NO python2
let g:python3_host_prog = '/home/gui/.pyenv/versions/py3nvim/bin/python'

let g:sqlfmt_command = "sqlformat"
let g:sqlfmt_options = "-r -k upper"
let g:sqlfmt_auto = 0


""""""""""""""""""""""""""""""""""""""
" AU COMMANDS
""""""""""""""""""""""""""""""""""""""
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown

" don't use arrowkeys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" really, just don't
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Left>  <NOP>
inoremap <Right> <NOP>

colorscheme ayudark
