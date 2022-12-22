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

lspconfig.pyright.setup({})
