
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
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'   
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
let g:netrw_keepdir=0
let g:netrw_banner=0

"python env configurations
let g:loaded_python_provider = 0 "NO python2
let g:python3_host_prog = '/home/gui/.pyenv/versions/py3nvim/bin/python'

let g:sqlfmt_command = "sqlformat"
let g:sqlfmt_options = "-r -k upper"
let g:sqlfmt_auto = 0

" Nice little way to save and save+exit
map Z :w! <CR>: echo "Saved"<CR>
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
inoremap <tab><tab> <esc>/<enter>"_c4l
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
" TELESCOPE
"""""""""""""""""""""""""""""""""""""""
nnoremap <leader>fw <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>n <cmd>lua require('telescope.builtin').buffers()<CR>

"""""""""""""""""""""""""""""""""""""""
" TREESITTER 
"""""""""""""""""""""""""""""""""""""""
" there should be a better way of doing this

lua <<EOF
require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim 
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}
EOF

"""""""""""""""""""""""""""""""""""""""
" COLOR SETTINGS 
"""""""""""""""""""""""""""""""""""""""
highlight Pmenu ctermbg=black ctermfg=white guibg=#5f5fff


"""""""""""""""""""""""""""""""""""""""
" NETRW INTERACTION
"""""""""""""""""""""""""""""""""""""""
nnoremap <C-e> :Lex <CR>
nnoremap <leader>re :let @/=expand("%:t") <Bar> execute ':Lex' expand("%:h") <CR>



"""""""""""""""""""""""""""""""""""""""
" GO STUFF
"""""""""""""""""""""""""""""""""""""""

lua <<EOF
  lspconfig = require "lspconfig"
  lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }
EOF

lua <<EOF
  -- …

  function goimports(timeout_ms)
    local context = { only = { "source.organizeImports" } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
  end
EOF
autocmd BufWritePre *.go lua goimports(999)
autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc "" Ctrl-x Ctrl-o completion
au FileType go nnoremap <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
au FileType go nnoremap <buffer> <leader>ref <cmd>lua vim.lsp.buf.references()<CR>
au FileType go nnoremap <buffer> <leader>vh <cmd>lua vim.lsp.buf.signature_help()<CR>
au BufWritePost *.go silent !gofmt -w %
