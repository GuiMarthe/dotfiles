
filetype plugin indent on
call plug#begin('~/.vim/plugged')
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-commentary'
	Plug 'michaeljsmith/vim-indent-object'
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
call plug#end()

filetype indent off
syntax on
filetype plugin indent on

set nocompatible
set clipboard+=unnamedplus

" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmode=longest,full

" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*
set wildmenu

" a bunch of sets
set guicursor=
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set history=700
set undolevels=700
set nu
set rnu
set cursorline
set laststatus=2


set isfname+=@-@
" set ls=0

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" netrw
let g:netrw_liststyle = 3
let g:netrw_preview = 1
let g:netrw_winsize = 30
let g:netrw_banner = 0

"python env configurations
let g:loaded_python_provider = 0 "NO python2
let g:python3_host_prog = '/home/gui/.pyenv/versions/py3nvim/bin/python'

let g:sqlfmt_command = "sqlfmt"
let g:sqlfmt_options = ""

" Nice little way to save and save+exit
map Z :w! <CR>
map ZX :wq <CR>

" Better code indentation
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

"""""""""""""""""""""""""""""""""""""""
" LEADER COMMANDS
"""""""""""""""""""""""""""""""""""""""
" Rebind <Leader> key
let mapleader = ","
" easier moving between tabs
map <Leader><Space> <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>
" go to last edited file
nnoremap <Leader><Leader> <c-^>
" greatest remap ever
vnoremap <leader>p "_dP

" next greatest remap ever : asbjornHaland
nnoremap <leader>y "*y
vnoremap <leader>y "*y
nnoremap <leader>Y gg"*yG

nnoremap <leader>d "_d
vnoremap <leader>d "_d

"""""""""""""""""""""""""""""""""""""""
" NAVIGATING WITH GUIDES
"""""""""""""""""""""""""""""""""""""""
inoremap <tab><tab> <esc>/<++><enter>"_c4l
vnoremap <tab><tab> <esc>/<++><enter>"_c4l
map <tab><tab> <esc>/<++><enter>"_c4l
inoremap <leader>gui <++>
nnoremap <leader>gui a<++><esc>

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

""""""""""""""""""""""""""""""""""""""
" AU COMMANDS
""""""""""""""""""""""""""""""""""""""

au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown

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


"""""""""""""""""""""""""""""""""""""""
" LSP MAPS
"""""""""""""""""""""""""""""""""""""""
lua require('lspconfig').jedi_language_server.setup{}
highlight Pmenu ctermbg=black ctermfg=white guibg=#5f5fff

nnoremap <c-]> :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>ref :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.signature_help())<CR>

"""""""""""""""""""""""""""""""""""""""
" TELESCOPE
"""""""""""""""""""""""""""""""""""""""
nnoremap <leader>fw :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>f :lua require('telescope.builtin').git_files()<CR>


