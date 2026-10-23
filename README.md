# Neovim: language tools, native completion, SQLite

Requires Neovim 0.12+, Git, Node.js/npm, Python, and platform build prerequisites
reported by `:checkhealth mason`. Use `:MasonToolsInstall`, wait for installation,
and restart. Mason tool names live ONLY in `lua/so/plugins/mason-tool-installer.lua`.

| Language | LSP | Diagnostics / linter | Formatter | Debug adapter |
| --- | --- | --- | --- | --- |
| Lua | lua_ls | Lua LS + luacheck | StyLua | local-lua-debugger-vscode (standalone Lua) |
| C/C++ | clangd | clangd compiler diagnostics/clang-tidy checks | clang-format | CodeLLDB |
| JavaScript/TS | ts_ls | ESLint | Prettier | js-debug-adapter (Node) |
| Typst | tinymist | Tinymist compilation diagnostics | Typstyle | No Typst DAP configured |
| Python | pyright | Pyright types + Ruff lint | Ruff | debugpy |

Clangd's optional clang-tidy analysis can be enabled in your project's `.clangd`:

```yaml
Diagnostics:
  ClangTidy:
    Add: ['bugprone-*', 'performance-*']
```

C projects need accurate compile flags (`compile_commands.json` recommended).
Mason installs tools, not a C compiler: install GCC/Clang/MSVC separately.
Compile with debugging information (`clang -g -O0 main.c -o main.exe`, for example).
F5 then asks for the compiled executable; it does not compile automatically.

ESLint requires a project-local installation and `eslint.config.*`. Use the
project's existing configuration; install ESLint if absent with `npm install -D eslint`
and configure it with `npm init @eslint/config@latest` in a project with package.json.

## Completion and formatting

Completion is entirely native. Tab accepts the selected suggestion (or first
suggestion if none selected); Ctrl-Space requests LSP completion. Shift-Tab cycles
backwards. Keep mini.bracketed/surround; mini.completion is not enabled.
`:SoCompletionClean` removes retired completion checkouts after restarting.

`:SoFormat`, Space c f, and backslash = format the full file. `:SoFormatInfo` shows
the tool arguments. `:SoLint` triggers Lua/HTML CLI linters; LSP diagnostics update
automatically. Space c d opens the diagnostic message; Space c q lists diagnostics.

Maintain rules in templates/formatting/{prettier.json,ruff.toml,stylua.toml,
clang-format.yaml}. Typstyle indent/width live in lua/so/formatting/config.lua.
The latter also selects tools and whether to use project configs. With project
config enabled, Typstyle follows its own supported configuration behavior;
this runner does not translate .editorconfig into Typstyle settings.

## Debugging

F5 start/continue; F10 step over; F11 into; F12 out. Space d b toggles a breakpoint;
Space d r opens the REPL; Space d v inspects a value; Space d x terminates.
Adapter definitions and launch configurations live in lua/so/plugins/dap.lua.

Python uses the active environment's Python, preferring cwd/.venv or cwd/venv.
Mason's separate debugpy environment hosts the adapter. Launch Neovim at the project
root. Node launch runs ordinary JS; for TypeScript, build with source maps and
attach to a Node process started with --inspect, or add your runtime's launch config.
Lua launch requires a standalone lua executable on PATH (or set
vim.g.so_lua_executable). It does not debug vim.* calls inside Neovim.
Typst has no debugger here; use Tinymist diagnostics and typst compile/watch.

## SQLite / Dadbod

Install the SQLite CLI separately (Windows Scoop: `scoop install sqlite`).
Restart the terminal and verify `sqlite3 --version` before opening Neovim.
No connection is hardcoded to one project or machine. Use:

```vim
:SoSqlite E:/New folder/inventory_erp/data/inventory.sqlite3
```

The entire argument is one path: leave spaces literal, without surrounding quotes.
The command checks the file exists, encodes the Windows path, registers it in DBUI,
and sets g:db. Select the connection in DBUI to browse tables. To inspect tables:

```vim
:DB SELECT name FROM sqlite_master WHERE type = 'table';
```

From a saved SQL buffer, `:%DB` executes the whole buffer against g:db. Visual
selection followed by `:DB` executes that range. Normal SQL writes also change
the database. `:SoSqlite` without arguments uses the current buffer's file path.
Use the explicit command for database files rather than opening them as text.
If old saved DBUI connections contain raw E:/ URLs, remove those stale connections.

## File explorer and cleanup

Oil and Neo-tree are removed in favor of Netrw: Space e e toggles the sidebar,
minus explores the current directory, and :Explore opens Netrw.
After restarting, old completion checkouts can be removed with :SoCompletionClean.
Oil/Neo-tree checkouts may remain physically installed but are no longer declared.
Remove them with vim.pack.del if still listed by vim.pack.get.

## Verification on your computer

Run `:checkhealth mason`, `:checkhealth vim.lsp`, `:checkhealth dap`.
Open a file of each language and inspect `:lua =vim.lsp.get_clients({bufnr=0})`.
Try :SoFormat on an unsaved edit; undo restores the previous text.
Debug a small program before using a project launch configuration.
The generated patch was checked for Lua syntax and clean application against the
uploaded snapshot; adapters and external programs still need Windows verification.
