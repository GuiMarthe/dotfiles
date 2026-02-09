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
  { 'rose-pine/neovim', name = 'rose-pine' },
  'sainnhe/gruvbox-material',
  { "quarto-dev/quarto-nvim", dependencies = { "jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter", },
  },
})

-- Dark/light mode support: reads ~/.theme-mode and watches for changes
local function apply_theme(mode)
  if mode == "light" then
    vim.o.background = "light"
    vim.cmd.colorscheme("gruvbox-material")
  else
    vim.cmd.colorscheme("rose-pine")
  end
end

local function read_theme_mode()
  local f = io.open(vim.fn.expand("~/.theme-mode"), "r")
  if f then
    local mode = f:read("*l")
    f:close()
    return (mode and mode:match("^%s*(.-)%s*$")) or "dark"
  end
  return "dark"
end

-- Apply theme on startup
apply_theme(read_theme_mode())

-- Watch ~/.theme-mode for changes (event-driven, no polling)
local theme_file = vim.fn.expand("~/.theme-mode")
local w = vim.uv.new_fs_event()
if w then
  local function on_change(err)
    if err then return end
    w:stop()
    apply_theme(read_theme_mode())
    w:start(theme_file, {}, vim.schedule_wrap(on_change))
  end
  w:start(theme_file, {}, vim.schedule_wrap(on_change))
end

-- Manual commands
vim.api.nvim_create_user_command("ThemeDark", function()
  apply_theme("dark")
end, {})
vim.api.nvim_create_user_command("ThemeLight", function()
  apply_theme("light")
end, {})
