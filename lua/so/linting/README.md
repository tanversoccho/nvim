# Language linting

This update builds on nvim-python-lint.patch. Python settings move here; the old module is a compatibility shim. The existing plugin/so-python-lint.lua loader now loads every language. No extra require is needed in so/plugins/init.lua.

## Install once inside Neovim

    :MasonInstall ruff lua-language-server luacheck htmlhint eslint-lsp powershell-editor-services

Restart Neovim after installation. The first startup installs nvim-lint through vim.pack; keep the resulting lockfile changes. PowerShell needs pwsh on PATH. If LuaCheck installation fails, inspect :MasonLog; it may need a working LuaRocks toolchain on Windows.

## Files

- init.lua: nvim-lint package, triggers, executable checks, project directories and shared keys.
- python.lua: native Ruff diagnostics, formatting and import actions.
- lua.lua: Lua language server plus LuaCheck (LuaJIT and vim global).
- html.lua: HTMLHint.
- javascript.lua: ESLint LSP for JS/TS/JSX/TSX.
- powershell.lua: PowerShell Editor Services with ScriptAnalyzer enabled.

## JavaScript / TypeScript project setup

In the actual JS/TS project folder, run:

    npm init @eslint/config@latest

Select the languages, browser/Node environment and framework used by that project. Accept installation of local dependencies. Keep an existing ESLint configuration rather than replacing it blindly. Installing eslint-lsp alone does not install the project's ESLint library or rules.

## Optional project rule files

HTMLHint reads .htmlhintrc in the project. LuaCheck reads .luacheckrc. Ruff reads pyproject.toml or ruff.toml. PowerShell uses PSScriptAnalyzerSettings.psd1 for project-specific analysis settings. Start with tool defaults, then add rules gradually. Lua's vim global and LuaJIT standard are configured in lua.lua; adjust those for non-Neovim Lua projects.

## Use and verify

Diagnostics from LSP are automatic. LuaCheck and HTMLHint run after opening/saving a named file and leaving insert mode; missing tools are skipped automatically. :SoLint or Space c l reports missing command-line tools. Space c d shows a diagnostic; Space c q lists diagnostics in quickfix. Python keeps Space c f for Ruff formatting and Space c a for code actions. JS/TS has Space c a for LSP actions. No automatic formatting or automatic code fixes on save are added.

After opening the appropriate source file, use :checkhealth vim.lsp to inspect Ruff, lua_ls, eslint or powershell_es. Use :SoLint to test Lua/HTML. A server listed under enabled configurations still needs to attach to the source buffer to produce diagnostics. If you already have another configuration enabling the same named LSP, this updates that configuration rather than creating a separate server name; restart Neovim after applying.

Examples: Lua `local unused = 1`; Python `print(undefined_name)`; JS `const unused = 1;` (with no-unused-vars enabled); PowerShell `Write-Host "hello"` (with AvoidUsingWriteHost enabled); HTML `<img src="test.png">` with an alt requirement enabled. Findings depend on active project rules.

## Recommended plugins

Native Neovim LSP with nvim-lspconfig for LSP diagnostics; nvim-lint for standalone tools; Mason for executable installation. Conform.nvim is a useful optional future addition for consistent multi-language formatting, but it is not a linter and is not installed by this patch. none-ls is an alternative bridge; it is not required by this setup.
