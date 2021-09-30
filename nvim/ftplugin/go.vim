
autocmd BufWritePre *.go lua require("goimports").goimports(999)
setlocal omnifunc=v:lua.vim.lsp.omnifunc "" Ctrl-x Ctrl-o completion
nnoremap <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <buffer> <leader>ref <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <buffer> <leader>vh <cmd>lua vim.lsp.buf.signature_help()<CR>
au BufWritePost *.go silent !gofmt -w %

