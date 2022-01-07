
autocmd BufWritePre *.go lua require("goimports").goimports(999)
au BufWritePost *.go silent !gofmt -w %

