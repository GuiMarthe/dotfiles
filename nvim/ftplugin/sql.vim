
setlocal encoding=utf-8

setlocal tabstop=4       " The width of a TAB is set to 4.
                         " Still it is a \t. It is just that
                         " Vim will interpret it to be having
                         " a width of 4.
setlocal shiftwidth=4    " Indents will have a width of 4

setlocal softtabstop=4   " Sets the number of columns for a TAB

setlocal expandtab       " Expand TABs to spaces

" Various error conditions.
syn match   sqlError        ")"                 " Lonely closing paren.
syn match   sqlError        ",\(\_\s*[;)]\)\@=" " Comma before a paren or semicolon.
syn match   sqlError        " $"                " Space at the end of a line.
" Comma before certain words.
syn match   sqlError        ",\_\s*\(\<\(asc\|desc\|exists\|for\|from\)\>\)\@="
syn match   sqlError        ",\_\s*\(\<\(group by\|into\|limit\|order\)\>\)\@="
syn match   sqlError        ",\_\s*\(\<\(table\|using\|where\)\>\)\@="

inoremap ;sel SELECT * FROM <++><Esc>FS
