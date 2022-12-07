nnoremap <C-j> :cnext<CR>zz
nnoremap <C-k> :cprev<CR>zz

command! Qbuffers call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr":v:val}'))

