-- a bunch of sets

vim.opt.clipboard:append( "unnamedplus" )

vim.opt.wildmode='longest,full'



vim.opt.wildignore:append '*.pyc'
vim.opt.wildignore:append '*_build/*'
vim.opt.wildignore:append '**/coverage/*'
vim.opt.wildignore:append '**/node_modules/*'
vim.opt.wildignore:append '**/android/*'
vim.opt.wildignore:append '**/ios/*'
vim.opt.wildignore:append '**/.git/*'
vim.opt.wildmenu = true


vim.opt.guicursor = {}
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.tabstop = 4 
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.nu = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.history = 700
vim.opt.undolevels = 700
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.isfname:append '@-@'

-- Give more space for displaying messages.
vim.opt.cmdheight= 2
-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50
-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append 'c'
vim.opt.completeopt = 'menu'
