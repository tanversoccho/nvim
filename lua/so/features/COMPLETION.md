# Native completion (Neovim 0.12)

Apply from the nvim root, then fully quit and restart Neovim. Do not just source init.lua: completion plugins may already be active in the session.

- Tab accepts the selected completion, or selects and accepts the first entry when none is selected.
- Ctrl-n / Ctrl-p navigate suggestions; Shift-Tab also moves to the previous suggestion.
- When the menu is closed, Tab/Shift-Tab jump through native snippet placeholders if active; otherwise they retain their usual behavior.
- Ctrl-Space requests LSP completion manually. Ctrl-x Ctrl-f is built-in filename completion. Ctrl-n is built-in word completion. Existing command-line completion is preserved.
- Enter retains its default behavior; it is not remapped by this module.
- Native autocomplete supplies buffer words; a completion-capable attached LSP provides language suggestions. Ruff supplies linting, not general Python completion; use your existing pylsp installation (or another Python completion server) alongside Ruff.
- Snippets returned by language servers use vim.snippet. External LuaSnip snippets, friendly-snippets, SQL Dadbod completion and Lazydev integration are removed.

The patch removes the external completion package declarations and require calls, deletes the supplied Blink setup, replaces Blink capabilities with native LSP capabilities, and removes the old manual Lua LSP start autocmd so Mason's native setup owns lua_ls. Other features and language linting modules remain.

Run :SoCompletionClean after restarting to remove only the retired completion plugin checkouts and lockfile entries. It refuses to remove an active plugin and never removes other packages. Old unreferenced placeholder config files can be deleted manually; they are not executed or dependencies.

Inspect :verbose imap <Tab>, :set autocomplete? complete? completeopt? and :checkhealth vim.lsp when troubleshooting. Check while editing a real source file, not the health buffer. Native completion depends on the project's server configuration and installed tools. Neovim LSP may warn about noninstalled servers separately.

Native feature file: lua/so/features/completion.lua. Automatic loader: plugin/so-native-completion.lua. Keep one loader; do not also call setup() elsewhere.
