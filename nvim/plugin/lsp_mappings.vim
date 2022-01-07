
 "" Ctrl-x Ctrl-o completion
set omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>ref <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>vh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <C-h> <cmd>lua vim.lsp.buf.hover()<CR>
