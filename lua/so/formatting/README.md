# One formatting setup

Use :SoFormat or Space c f to format a whole named source file. gggqG uses the same runner. Any gq range formats the WHOLE document; partial parser ranges are intentionally unsupported. Your existing backslash-equals mapping remains indentation only. There is no format-on-save.

Maintain formatter selection in lua/so/formatting/config.lua and style in templates/formatting/prettier.json, ruff.toml and stylua.toml. Web/Lua indentation defaults to 2 spaces; Python to 4. To use 2 for Python, change indent-width in ruff.toml and the Python indent_size in your project's .editorconfig.

By default, YOUR Neovim rule files win over project formatter configuration. Prettier ignores .editorconfig for formatting in this mode. .editorconfig still controls editor indentation; keep it aligned. Set use_project_config=true to use the formatter's normal project config discovery instead. There is no automatic writing of .prettierrc/pyproject files.

Install via :SoFormatToolsInstall, wait for Mason to finish, then restart. This does not run automatically. Keep prettier, ruff and stylua in your EXISTING mason-tool-installer ensure_installed list for future machines. Keep language servers and the HTML/Lua linters; they serve different purposes.

Run :SoFormatInfo to see the exact command and configuration path for the current file. Run :checkhealth vim.lsp separately for diagnostics/completion. This formatter bypasses LSP formatting, so several attached servers cannot compete to format one file.

The runner invokes executables with argument arrays, not shell command strings. On Windows it runs Prettier through node and its JS entrypoint, bypassing .cmd shim/filter quoting. It searches a project-local Prettier first, then the default Mason install, then common npm global layouts. For other layouts set prettier_cli to the absolute prettier.cjs path in config.lua.

Formatting uses the current unsaved buffer. A nonzero exit, timeout, missing executable or unexpected empty output leaves the buffer untouched. Success changes only the buffer; save with :w. Undo with u. Parser errors are displayed instead of inserted into your source code.

Cleanup is explicit: inspect the retire list in config.lua, then run :SoFormatToolsClean. It uninstalls black, darker, csskit, eslint_d, fixjson, latexindent, markdown-toc, markdownlint, markdownlint-cli2, pydocstyle and vale IF installed. Remove any of those names from other ensure_installed lists too, or they will be reinstalled. Do not clean a tool you still use in another workflow: remove it from retire first. Existing clangd, texlab, markdown-oxide, ast-grep and other LSPs are preserved.

This additive patch does not delete older configuration code. Its late loader and buffer hooks replace the earlier HTML-only formatprg and Python formatting mapping for supported filetypes. Once it works, the old manual HTML formatting blocks and plugin/so-formatting.lua may be removed if they only contain that previous formatter configuration; other content should be retained.

Configuration and behavior have been checked locally with mocks; actual Windows tool execution still needs testing. Neovim 0.12 is expected.
