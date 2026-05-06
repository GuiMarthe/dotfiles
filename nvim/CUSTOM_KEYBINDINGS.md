# Custom Neovim Keybindings

**Leader key:** `,` (comma)

## General (`lua/general_mappings.lua`)

| Mode | Keys | Action |
|---|---|---|
| n/v/i | `<Up>` `<Down>` `<Left>` `<Right>` | Disabled (forces hjkl) — defined in `init.lua` |
| all | `Z` | Save file (`:w!`) |
| all | `ZX` | Save and quit (`:wq`) |
| v | `<` / `>` | Indent left/right, keep selection |
| v | `J` / `K` | Move selected lines down/up |
| n | `J` | Join lines, keep cursor position |
| n | `<C-d>` / `<C-u>` | Half-page down/up, recentered |
| n | `n` / `N` | Next/prev search result, recentered |
| n | `<leader>g` | Substitute word under cursor across file |
| n | `<leader><leader>` | Switch to alternate buffer (`<C-^>`) |
| x | `<leader>p` | Paste without overwriting register |
| n/v | `<leader>y` | Yank to system clipboard |
| n | `<leader>Y` | Yank line to system clipboard |
| n/v | `<leader>d` | Delete without overwriting register |
| i/v/all | `<tab><tab>` | Jump to next `<++>` placeholder |
| i | `<leader>gui` | Insert `<++>` placeholder |
| n | `<leader>gui` | Append `<++>` placeholder |
| n | `<C-e>` | Open netrw (`:Lex`) |

## Telescope (`after/plugin/telescope_mappings.lua`)

| Keys | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Git files |
| `<leader>lg` | **Live grep** |
| `<leader>sw` | Grep word under cursor |
| `<leader>bb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fz` | Zotero references (`:Zseek`) |
| `<leader>rf` | LSP references |
| `<leader>ds` | LSP document symbols |

### Inside a Telescope picker (defaults)

| Keys | Action |
|---|---|
| `<Tab>` | Toggle multi-selection on entry |
| `<C-q>` | Send **all** results to quickfix list |
| `<M-q>` | Send **selected** results (multi-selected) to quickfix list |

## Harpoon (`after/plugin/harpoon_mappings.lua`)

| Keys | Action |
|---|---|
| `<leader>a` | Add file to harpoon |
| `<leader>n` | Toggle quick menu |
| `<leader>1`–`<leader>4` | Jump to harpoon file 1–4 |

## LSP (`after/plugin/lsp_settings.lua`, buffer-local on attach)

| Mode | Keys | Action |
|---|---|---|
| n | `<C-]>` | Go to definition |
| n | `K` | Hover |
| n | `<leader>vws` | Workspace symbol |
| n | `<leader>vd` | Open diagnostic float |
| n | `[d` / `]d` | Next/prev diagnostic |
| n | `<leader>cdf` | Code action |
| n | `<leader>ref` | References |
| n | `<leader>ren` | Rename |
| i | `<C-h>` | Signature help |

## Quickfix (`after/plugin/quickfix_mappings.lua`)

| Keys | Action |
|---|---|
| `<C-j>` | Next quickfix item (recentered) |
| `<C-k>` | Previous quickfix item (recentered) |

## Quarto (`after/plugin/quarto.lua`)

| Keys | Action |
|---|---|
| `<leader>qp` | Quarto preview |
| `<leader>qpf` | Quarto preview (file-scoped) |
| `<leader>qr` | Close Quarto preview |
| `<leader>rc` | Run current cell |
| `<leader>ra` | Run cell and all above |
| `<leader>rA` | Run all cells |

## Filetype-specific snippets

### Python (`ftplugin/python.vim`, insert mode)
| Keys | Inserts |
|---|---|
| `<leader>def` | Function snippet |
| `<leader>class` | Class snippet |
| `<leader>main` | Script snippet |
| `<leader>tran` | Transformer snippet |
| `<leader>pr` | `print(<++>)` |
| `<leader>l` | `import ipdb;ipdb.set_trace();` |

### Markdown (`ftplugin/markdown.vim`, insert mode)
| Keys | Inserts |
|---|---|
| `;1` / `;2` / `;3` | H1 / H2 / H3 heading |
| `;i` | Image link `![](...)` |
| `;a` | Link `[](...)` |
| `;b` | Bold `**...**` |
| `;s` | Strikethrough `~~...~~` |
| `;e` | Italic `*...*` |

### SQL (`ftplugin/sql.vim`, insert mode)
| Keys | Inserts |
|---|---|
| `;sel` | `SELECT * FROM <++>` |

### JavaScript (`ftplugin/javascript.vim`, insert mode)
| Keys | Inserts |
|---|---|
| `;anf` | Async function snippet |
| `;vaf` | Variable arrow function snippet |
| `;af` | Arrow function snippet |
| `;if` | If-statement snippet |
| `;cl` | `console.log` snippet |

## Misc (`plugin/old_commands_i_havent_ported_to_lua_yet.vim`)

| Mode | Keys | Action |
|---|---|---|
| i | `<leader>time` | Insert current time (`:InsertTime`) |
| i | `<leader>date` | Insert current date (`YYYY-MM-DD`) |
