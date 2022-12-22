local lspconfig = require('lspconfig')

local function on_attach(client)
end

lspconfig.gopls.setup({
    on_attach=on_attach,
    cmd = {"gopls", "--remote=auto", "serve"},
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})

-- lspconfig.jedi_language_server.setup({})
lspconfig.pyright.setup({})
