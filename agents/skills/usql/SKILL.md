---
name: usql
description: >-
  Use usql (the universal command-line SQL client) to connect to any database,
  run queries, inspect schema, and export results to CSV/JSON. Trigger this
  whenever the user wants to query a database from the terminal, run ad-hoc SQL,
  dump a table or query result to a CSV/JSON file, explore an unfamiliar
  schema (list tables/columns), or mentions usql, DSN connection strings, or
  connecting to Postgres/MySQL/SQLite/BigQuery/Snowflake/DuckDB/etc. from the
  command line. Prefer this over hand-rolling database-specific CLIs (psql,
  mysql, bq) when the user just needs to run SQL and get results out.
---

# usql — universal command-line SQL client

`usql` is a single binary that speaks to ~50 databases (Postgres, MySQL,
SQLite, BigQuery, Snowflake, DuckDB, SQL Server, ClickHouse, and more) using
one consistent interface and psql-style meta commands. Think "psql for
everything." The whole point is that you learn one tool instead of `psql`,
`mysql`, `bq`, `sqlite3`, etc.

Two things make usql productive: **the DSN** (how you connect) and **output
control** (how you get results out, especially to files). Most tasks are one
non-interactive command.

## Connecting: the DSN

usql takes a connection string (DSN) as its only positional argument. The
general shape is:

```
driver://user:pass@host:port/dbname?opt=val
```

Common examples:

```bash
usql postgres://user:pass@localhost:5432/mydb
usql pg://localhost/mydb                     # short driver alias, local socket
usql mysql://user:pass@localhost/mydb
usql sqlite:///path/to/file.db               # or just: usql my.db
usql duckdb:///path/to/file.duckdb
usql snowflake://user:pass@account/db/schema
usql sqlserver://user:pass@host/instance
usql bq://project-id/dataset                 # BigQuery (uses ambient gcloud auth)
```

Every driver has short aliases (`pg`, `my`, `sq`, `bq`, `dk`, `sf`, `ms`...).
To see the full list installed on this machine and their aliases:

```bash
usql -c '\drivers'
```

File-based databases (SQLite, DuckDB) can often be opened by path alone —
`usql data.db` — usql infers the driver from the extension.

### Named connections (skip retyping the DSN)

If the user connects to the same database repeatedly, set up a named
connection once in `~/.usqlrc` so they can just type `usql mydb`:

```
\cset mydb postgres://user:pass@localhost/mydb
```

Then `usql mydb` connects. You can also define one inline for a single
invocation with `-N name=DSN`. List configured names with `usql -c '\cset'`.

## Running queries

Three modes — pick based on the task:

**One-shot (best for scripting / a single question):**
```bash
usql pg://localhost/mydb -c "SELECT count(*) FROM orders"
```

**From a .sql file:**
```bash
usql pg://localhost/mydb -f report.sql
```

**Interactive session** (exploration, multiple queries):
```bash
usql pg://localhost/mydb
```
End statements with `;`. Quit with `\q`.

You can inline a file's contents into `-c` when you want file SQL plus flags:
```bash
usql pg://localhost/mydb -C -o out.csv -c "$(cat report.sql)"
```

### Gotcha: leading `/* */` block comment produces a silently empty result

If a `.sql` file (or a string passed to `-c`) **starts** with a `/* ... */`
block comment, usql can silently return nothing — `-f`/`-c` complete with exit
0 and write an **empty output file**, no error. The SQL itself is fine (a
dry-run against the DB and the stripped version both succeed); usql just
mishandles the leading block comment. Strip the opening comment before
executing:

```bash
# drop everything from line 1 through the line containing the closing */
sed '1,/\*\//d' report.sql > report.clean.sql
usql pg://localhost/mydb -C -q -o out.csv -f report.clean.sql

# or inline, no temp file:
usql pg://localhost/mydb -C -q -o out.csv -c "$(sed '1,/\*\//d' report.sql)"
```

If a query mysteriously yields an empty file, check the top of the SQL for a
leading block comment first — it's a much more likely cause than a bad query
or connection.

## Exporting results to a file (CSV / JSON)

This is one of the most common asks. The flags that matter:

- `-C` / `--csv` → CSV output mode
- `-J` / `--json` → JSON output mode
- `-o FILE` → write output to a file instead of stdout
- `-q` / `--quiet` → suppress the startup banner lines (pager/line-style
  messages) so the file/stdout is clean
- `-F ';'` → change the field separator (default `,` in CSV mode)

**CSV export:**
```bash
usql pg://localhost/mydb -C -q -o orders.csv -c "SELECT * FROM orders"
```

**JSON export:**
```bash
usql pg://localhost/mydb -J -q -o orders.json -c "SELECT * FROM orders"
```

Note: usql prints a few startup lines (e.g. `Pager usage is always.`, `Line
style is unicode.`) to **stderr**. Without `-q` those appear in the terminal
but do NOT corrupt the `-o` file. Add `-q` when you want a fully clean run.

**Inside an interactive session**, redirect with `\o` or send a single query's
results to a file with `\g`:
```
\pset format csv      -- switch format to CSV
\o out.csv            -- redirect all subsequent output to a file
SELECT * FROM orders;
\o                    -- stop redirecting (back to screen)

-- or, per-query, without changing global output:
SELECT * FROM orders \g (format=csv) out.csv
```

## Exploring the schema (meta commands)

usql mirrors psql's backslash commands:

| Command | What it does |
|---|---|
| `\l` | list databases |
| `\dn` | list schemas |
| `\dt` | list tables |
| `\dv` | list views |
| `\d name` | describe a table/view (columns, types) |
| `\df` | list functions |
| `\di` | list indexes |
| `\c DSN` | connect to another database mid-session |
| `\conninfo` | show current connection info |
| `\?` | help on all backslash commands |

Add `+` for more detail (`\dt+`) and `S` to include system objects (`\dtS`).

Non-interactive equivalent:
```bash
usql pg://localhost/mydb -c '\dt'
usql pg://localhost/mydb -c '\d orders'
```

### Gotcha: not every driver supports meta commands

Meta commands like `\dt` and `\d` are implemented per-driver. Cloud/analytics
drivers often don't support them and will error with something like
`describe commands not supported by <driver> driver` (BigQuery is one such
case). When that happens, fall back to the SQL-standard **INFORMATION_SCHEMA**,
which almost every database exposes:

```sql
-- list tables
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- describe a table's columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'orders';
```

For BigQuery specifically the schema is dataset-qualified, e.g.
`` `project.dataset`.INFORMATION_SCHEMA.TABLES ``. When a `\d`-style command
fails, reach for INFORMATION_SCHEMA rather than assuming the connection is
broken.

## Output formatting (screen)

For human-readable terminal output you usually want the default aligned table.
Handy `\pset`/flag toggles:

- `\x on` (or `-x`) → expanded/vertical layout, great for wide rows
- `\a` → toggle aligned vs. unaligned
- `\t on` (or `-t`) → tuples only (no header/footer)
- `\pset format {aligned|csv|json|unaligned|html|vertical}` → set format
- `-H` → HTML table output

## Practical recipes

**Quick row count across a remote table:**
```bash
usql pg://analytics.example.com/warehouse -c "SELECT count(*) FROM events"
```

**Dump a filtered query to CSV for a spreadsheet:**
```bash
usql my://db/shop -C -q -o recent_orders.csv \
  -c "SELECT id, total, created_at FROM orders WHERE created_at > '2025-01-01'"
```

**Copy data between two databases** (usql can read from one DSN, write to
another with `\copy`):
```bash
usql -c "\copy pg://src/db sqlite:///local.db 'SELECT * FROM users' users"
```

**Run a saved report and pipe results to another tool:**
```bash
usql pg://localhost/mydb -C -q -f report.sql | column -t -s,
```

## Guidance

- Default to the **one-shot `-c` form** for a single question; it's scriptable
  and leaves no session open.
- When exporting, always pair the format flag (`-C`/`-J`) with `-o` and add
  `-q` for a clean file.
- If a `\d`/`\dt` meta command errors on a cloud driver, don't retry blindly —
  switch to `information_schema` queries.
- Empty output file with exit 0? Suspect a leading `/* */` block comment in the
  SQL and strip it with `sed '1,/\*\//d'` before rerunning.
- Prefer short driver aliases and named connections to keep commands readable.
- Discover exactly what's installed and supported on the current machine with
  `usql -c '\drivers'` and `usql -c '\?'` rather than guessing.
