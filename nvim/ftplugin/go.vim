
autocmd BufWritePre *.go lua require("goimports").goimports(999)
autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc "" Ctrl-x Ctrl-o completion
au FileType go nnoremap <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
au FileType go nnoremap <buffer> <leader>ref <cmd>lua vim.lsp.buf.references()<CR>
au FileType go nnoremap <buffer> <leader>vh <cmd>lua vim.lsp.buf.signature_help()<CR>
au BufWritePost *.go silent !gofmt -w %
