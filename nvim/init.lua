vim.g.mapleader = ","

require("globals")
require("a_bunch_of_sets")
require("netrw")
require("general_mappings")


vim.g.loaded_python_provider = 0 --NO python2
vim.g.python3_host_prog = vim.fn.expand('~/.pyenv/versions/py3nvim/bin/python')
vim.g.sqlfmt_command = "sqlformat"
vim.g.sqlfmt_options = "-r -k upper"
vim.g.sqlfmt_auto = 0
vim.opt.autoread = true

vim.cmd.syntax('on')
vim.cmd.filetype('plugin', 'indent', 'on')

-- don't use arrowkeys
vim.keymap.set({ "n", "v", "i" }, "<Up>", "<NOP>")
vim.keymap.set({ "n", "v", "i" }, "<Down>", "<NOP>")
vim.keymap.set({ "n", "v", "i" }, "<Left>", "<NOP>")
vim.keymap.set({ "n", "v", "i" }, "<Right>", "<NOP>")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-commentary',
  'vim-scripts/ReplaceWithRegister',
  'ThePrimeagen/harpoon',
  'ayu-theme/ayu-vim',
  'slarwise/vim-tmux-send',
  { 'ekalinin/Dockerfile.vim', ft = 'dockerfile' },
  { 'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  { 'folke/lazydev.nvim', ft = 'lua' },
  { 'VonHeikemen/lsp-zero.nvim',
    dependencies = {
      -- LSP Support
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',

      -- Snippets
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    }
  },
  { 'rose-pine/neovim', name = 'rose-pine', config = function() vim.cmd('colorscheme rose-pine') end },
  { "quarto-dev/quarto-nvim", dependencies = { "jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter", },
  },
})

vim.cmd.colorscheme('rose-pine')
