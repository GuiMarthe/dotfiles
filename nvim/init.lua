
require("globals")
require("a_bunch_of_sets")
require("netrw")
require("general_mappings")


vim.g.loaded_python_provider = 0 --NO python2
vim.g.python3_host_prog = '/home/gui/.pyenv/versions/py3nvim/bin/python'
vim.g.sqlfmt_command = "sqlformat"
vim.g.sqlfmt_options = "-r -k upper"
vim.g.sqlfmt_auto = 0

vim.g.mapleader = ","
vim.cmd.colorscheme('ayudark')
vim.cmd.syntax('on')
vim.cmd.filetype('plugin', 'indent', 'on')

-- don't use arrowkeys
vim.keymap.set({ "n", "v", "i" }, "<Up>", "<NOP>")
vim.keymap.set({ "n", "v", "i" }, "<Down>", "<NOP>")
vim.keymap.set({ "n", "v", "i" }, "<Left>", "<NOP>")
vim.keymap.set({ "n", "v", "i" }, "<Right>", "<NOP>")

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-commentary'
  use 'vim-scripts/ReplaceWithRegister'
  use {'ekalinin/Dockerfile.vim', ft = 'dockerfile'}
  use { 'psf/black', ft = 'python' }
  use 'ThePrimeagen/harpoon'
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { 'nvim-lua/plenary.nvim' }}
  use 'ayu-theme/ayu-vim'
  use 'slarwise/vim-tmux-send'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
end)
