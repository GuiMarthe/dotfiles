
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
  use 'ThePrimeagen/harpoon'
  use 'ayu-theme/ayu-vim'
  use 'slarwise/vim-tmux-send'
  use {'ekalinin/Dockerfile.vim', ft = 'erfile'}
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.8', requires = { 'nvim-lua/plenary.nvim' }}
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use { 'VonHeikemen/lsp-zero.nvim', requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }
  use { 'rose-pine/neovim', as = 'rose-pine', config = function() vim.cmd('colorscheme rose-pine') end }
end)

vim.cmd.colorscheme('rose-pine')
