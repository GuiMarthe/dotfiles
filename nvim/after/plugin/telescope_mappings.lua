local builtin = require("telescope.builtin")

-- File finding
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git files" })

-- Grep/Search
vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search word under cursor" })

-- Buffers & navigation
vim.keymap.set("n", "<leader>bb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })

-- Zotero
vim.keymap.set("n", "<leader>fz", ":Telescope zotero<CR>", { desc = "Zotero references" })

-- LSP
vim.keymap.set("n", "<leader>rf", builtin.lsp_references, { desc = "LSP references" })
vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Document symbols" })
