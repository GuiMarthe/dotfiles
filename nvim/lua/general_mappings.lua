
-- my weird way of constantly saving and exiting
vim.keymap.set("", "Z", ':w! <CR>: echo "Saved"<CR>')
vim.keymap.set("", "ZX", ':wq <CR>')

 -- Better code indentation
vim.keymap.set("v", "<", '<gv')
vim.keymap.set("v", ">", '>gv')

-- Line movements
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- better line joining
vim.keymap.set("n", "J", "mzJ`z")

-- screen centered page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- screen centered searches
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- search and replace word under cursor
vim.keymap.set("n", "<leader>g", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- go to last edited file
vim.keymap.set("n",  '<leader><leader>',  '<c-^>')
-- vim.keymap.set("n",  '<leader><leader>',  ':echo "roger roger"<cr>')

-- make leader yank, delete, paste not overwrite the register
-- I like replace with register for some use-cases though
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Navigating with tabs, mr Smith style.
vim.keymap.set("i",  "<tab><tab>",   '<esc>/<enter>"_c4l')
vim.keymap.set("v",  "<tab><tab>",   '<esc>/<++><enter>"_c4l')
vim.keymap.set("",   "<tab><tab>",   '<esc>/<++><enter>"_c4l')
vim.keymap.set("i",  "<leader>gui",  '<++>')
vim.keymap.set("n",  "<leader>gui",  'a<++><esc>')

vim.keymap.set("n", '<C-e>',  ':Lex <CR>')

