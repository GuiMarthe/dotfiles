"highlight Normal ctermfg=grey ctermbg=darkblue

let g:javascript_plugin_flow = 1
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

" anonymous function
inoremap ;anf <Esc>:-1read /home/gui/.vim/snippets/js_snippets/af<CR>
" anonymous attributed function
inoremap ;vaf <Esc>:-1read /home/gui/.vim/snippets/js_snippets/vaf<CR>
" arrow funtion 
inoremap ;af <Esc>:-1read /home/gui/.vim/snippets/js_snippets/arf<CR>
" if conditional
inoremap ;if <Esc>:-1read /home/gui/.vim/snippets/js_snippets/if<CR>
" console.log
inoremap ;cl <Esc>:-1read /home/gui/.vim/snippets/js_snippets/cl<CR>

