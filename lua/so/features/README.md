# Native editing features

No external plugins. The plugin/so-native-editing.lua file is your own automatic startup loader; "plugin" is Neovim's standard startup directory.

- pairs.lua: double quotes, (), [], {} in normal editing buffers. Cursor stays between the pair. Typing an existing closing delimiter skips it. Escaped double quotes stay literal. No single-quote, backtick, Backspace or Enter mappings are changed.
- sql.lua: only the sql filetype gets the buffer-local sf abbreviation. Type sf followed by Space to obtain `select * from `; abbreviations may also expand before punctuation. It is text expansion, not an SQL parser; it can expand inside comments or strings.
- html.lua: in the html filetype, typing > after an opening tag inserts the closing tag and leaves the cursor between them. Attributes and ordinary multiline opening tags are supported. Void elements, self-closing tags, closing tags and an immediately existing closing tag are skipped.

HTML closing tags are enabled by default. Use :SoHtmlAutoCloseToggle to toggle for the current session. For a persistent default, put `vim.g.so_html_autoclose = false` in init.lua before startup plugins load. Other filetypes, including JSX/TSX, are not changed.

This is intentionally lightweight matching. It does not fully parse HTML, embedded script/style content or template languages, and scans at most 100 lines before the cursor. Toggle it off when editing content it cannot interpret.

The pairs mappings intentionally replace existing global Insert-mode mappings for these keys. Existing buffer-local or later-loaded plugin mappings can override them; inspect :verbose imap followed by the relevant key if behavior differs. This patch does not remove your installed plugins or previous configuration.
