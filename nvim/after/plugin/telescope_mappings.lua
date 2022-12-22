local tsc = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", tsc.git_files)
-- vim.keymap.set("n", "<leader>fw", tsc.grep_string( search = vim.fn.input("Grep For > ")))
vim.keymap.set("n", "<leader>rf", tsc.lsp_references)
vim.keymap.set("n", "<leader>bb", tsc.buffers)

