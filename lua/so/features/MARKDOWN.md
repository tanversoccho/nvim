# Native Markdown decorations

This feature uses Neovim extmarks only: no rendering plugin, Tree-sitter parser,
external program, or font package is required. Requires Neovim 0.12 (your current
configuration's baseline). Your theme supplies the default colors.

## Use

Restart Neovim, then open any file with `:set filetype?` showing `markdown`.
Decorations are enabled automatically. `:SoPreviewToggle` toggles the current
buffer. Typst and other filetypes are excluded.

Features:

- Color for ATX headings (`#` through `######`). Heading markers remain visible.
- Full-width background for backtick/tilde fenced code blocks and a language label.
- Display unchecked/checked list tasks as checkbox symbols (including numbered lists).
- Highlight same-line inline code, inline links, images and HTTP(S) autolinks.
- Reveal plain source on the current cursor line, in Normal and Insert modes.

These are display decorations: no content is rewritten, no undo entries are
created, and saved Markdown keeps its original characters. Text selection and
yanking still use the source. Turn the feature off when you want an undecorated
view. Code-block syntax colors still depend on your regular syntax/Tree-sitter
configuration; this feature only adds backgrounds and labels.

## Customize

Edit `plugin/so-markdown-preview.lua`. It automatically loads your own module
`lua/so/features/markdown.lua`; do not also call setup from another file.
Restart after changing settings.

- enabled: default on/off for Markdown buffers.
- hide_cursor_line: reveal raw source under the active cursor.
- headings / code_blocks / code_labels / checkboxes / inline_code / links:
  independently enable each feature.
- debounce_ms: delay between navigation/edits and redraw, default 60 milliseconds.
- max_lines: skip decoration for very large buffers (default 20000 lines).

To change colors, define highlight groups in your theme's ColorScheme callback:

```lua
vim.api.nvim_set_hl(0, "SoMarkdownCode", { bg = "#24283b" })
vim.api.nvim_set_hl(0, "SoMarkdownCodeLabel", { fg = "#7aa2f7" })
vim.api.nvim_set_hl(0, "SoMarkdownHeading1", { fg = "#bb9af7", bold = true })
```

Other groups: SoMarkdownHeading2 through SoMarkdownHeading6,
SoMarkdownInlineCode, SoMarkdownLink, SoMarkdownChecked, SoMarkdownUnchecked.
Without custom groups, these link to standard groups from your active theme.
Checkbox symbol appearance depends on your terminal font.

## Scope and limitations

This is a lightweight source renderer, not a complete CommonMark parser or a
browser/PDF preview. It handles ordinary top-level fenced blocks and simple
same-line markup. It does not render tables, reference links, multiline inline
markup, Setext headings, or fenced blocks nested inside lists/quotes. HTML/comment
containers and YAML frontmatter are not parsed specially. There is no automatic
link opening or checkbox mutation. Extmarks are buffer-wide, so multiple windows
showing one buffer share the decoration state and current active cursor reveal.

Keep Markview removed to avoid two renderers decorating the same content. Your
separate markdown-preview package is not required by this feature.

## Installation and removal

Apply the supplied patch from the Neovim config root, restart, and open Markdown.
The patch adds only this document, the module, and its loader.
To remove the feature, delete `plugin/so-markdown-preview.lua` and
`lua/so/features/markdown.lua` and restart. No vim.pack deletion is needed.

## Validation

Lua syntax and mocked Neovim API tests cover fence matching (including longer
fences), language labels, checkboxes, headings, inline code/link separation,
escaped links, UTF-8 column bounds, cursor-line reveal, toggle behavior, Typst
exclusion, and preservation of source text. Actual terminal appearance has not
been visually tested in Windows Neovim.
