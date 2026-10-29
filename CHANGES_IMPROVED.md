# Changes in this conservative revision (2026-10-29)

This copy preserves your plugin manager, native completion with Tab, LSP setup,
Netrw, SQLite, debugger, statusline, and custom feature modules.

1. `scrolloff`: 99 -> 8, to prevent excessive scrolling on normal-sized windows.
2. Global `tabstop`: 4 -> 2, consistent with global `shiftwidth` and
   `softtabstop`. `after/ftplugin/lua.lua` still controls Lua explicitly.
   Change language-specific indentation in `after/ftplugin/<filetype>.lua`.
3. Stop overwriting `formatexpr` for every supported filetype. Previously,
   `gq` could format the *whole file* instead of only the chosen text.
   Use `:SoFormat` or `<leader>cf` for whole-file formatting.
4. Mason tool-installer check interval: 0 -> 24 hours; fewer needless checks.
5. Replace one legacy Nerd Font hint sign with a portable bullet glyph.

## Installation on Windows

Back up your existing `%LOCALAPPDATA%\nvim` folder, then replace its contents
with the contents of `nvim_improved.zip` (not the ZIP itself).
Restart Neovim and try `:checkhealth`, `:SoFormatInfo`, `:SoFormat`,
`:verbose setlocal shiftwidth? tabstop? softtabstop? expandtab?`,
and `:verbose setlocal formatexpr?`.

Caution: this revision was statically audited; Neovim is not installed in the
build environment, so runtime verification is still needed on your Windows PC.
External tools (Java, C compiler, Tree-sitter parser build tools) are not bundled.
