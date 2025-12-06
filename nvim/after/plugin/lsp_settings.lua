-- Modern lsp-zero v3.x setup (December 2025)
local lsp_zero = require('lsp-zero')

-- Setup lsp-zero's on_attach with your custom keybindings
lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    
    -- Stop eslint if present
    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end
    
    -- Your custom keybindings
    vim.keymap.set("n", "<c-]>", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>cdf", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>ref", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>ren", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- Setup Mason (LSP installer)
require('mason').setup({})
require('mason-lspconfig').setup({
    -- ensure_installed uses the NEW names
    ensure_installed = {
        'pyright',
        'lua_ls',  -- NOTE: Changed from 'sumneko_lua' to 'lua_ls'
    },
    handlers = {
        -- Default handler for all servers
        lsp_zero.default_setup,
        
        -- Custom handler for lua_ls to fix 'vim' global warning
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })
        end,
    }
})

-- Setup nvim-cmp (autocompletion)
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
    },
})

-- Custom diagnostic signs (optional)
local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
