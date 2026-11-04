# Native Neovim `after/lsp/` overrides

These files are **not** loaded using `require()`. Neovim merges them with the
server defaults supplied by `nvim-lspconfig` when those servers are enabled.

Active servers are listed in `lua/so/plugins/nvim-lspconfig.lua`. This package
keeps all ten server names active but moves the existing Lua and Typst settings
into their respective `after/lsp/` files. `pyright.lua` adds optional basic
Python type checking (remove that file if you prefer Pyright defaults).

Other enabled servers (`clangd`, `ruff`, `ts_ls`, `eslint`, `cssls`, `html`, and
`powershell_es`) continue using upstream definitions. Add an `after/lsp/NAME.lua`
only when you have settings to override; empty files are unnecessary.

To verify in a language buffer:

- `:checkhealth vim.lsp`
- `:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))`
- `:lua vim.print(vim.lsp.config.lua_ls)` (from any buffer)

Restart Neovim after applying. Language-server executables must be installed
separately (for example through Mason). No changes to `vim.pack` are required.
