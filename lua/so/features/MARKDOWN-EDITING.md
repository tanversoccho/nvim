# Markdown tables and command-line pairs

These are native features; no vim.pack package is added. Apply this patch after
the native Markdown renderer patch, then restart Neovim. Table alignment and
command-line pairing also work independently of that renderer.

## Markdown tables

Tables align on InsertLeave and BufWritePre. Type a header row and a delimiter
row with at least three hyphens per column. Press Escape to align the table:

```markdown
| Name | Quantity |
| :--- | ---: |
| Pencil | 12 |
| Notebook | 3 |
```

The source becomes:

```markdown
| Name     | Quantity |
| :------- | -------: |
| Pencil   | 12       |
| Notebook | 3        |
```

Manual command: `:SoMarkdownTableAlign` (aligns all recognized tables in the
current Markdown buffer). The command is harmless in other filetypes.
Unlike visual decorations, table alignment intentionally changes buffer text;
saving writes those changes, and undo can restore the previous layout.
The formatter leaves table cells' contents intact, apart from surrounding spaces.
It normalizes outer pipes and separator widths, preserving left/right/center
alignment markers. Cell text is padded on the right; the colon markers
control alignment in Markdown viewers.

Change `plugin/so-markdown-tables.lua` to `{ auto_align = false }` to use only
the manual command. The implementation is `lua/so/features/markdown_tables.lua`.
No Tab mapping is added; your native completion's Tab behavior stays available.

Scope: ordinary rectangular pipe tables outside top-level fenced code blocks,
with up to three leading spaces. Escaped pipes and pipes in backtick spans are
preserved. Nested list/blockquote tables and multiline cells are not supported.
HTML/comment/frontmatter contexts are not specially parsed. Very large files
are skipped using max_lines (default 20000). There is no table grid rendering,
formula evaluation, row creation, or table-cell navigation.

## Pairing in the colon command line

In `:` mode:

- `(` inserts `()` with the cursor between them.
- `"` inserts `""` with the cursor between them.
- Typing `)` or `"` before an existing matching closer moves over it.
- Backspace between an empty pair removes both characters.
- A backslash before an opening character suppresses automatic pairing.
- `/` and `?` search prompts keep their normal behavior.

Use Ctrl-V followed by a character to insert it literally when writing a command
that needs a single quote character or parenthesis (for example an Ex comment or
substitution pattern). This is lightweight pairing, not a parser for Vimscript,
Lua, SQL, shell commands, or regular expressions. Double-quote parity is used to
avoid adding an extra pair when finishing an existing double-quoted string.

Edit `lua/so/features/cmdline_pairs.lua` to maintain the logic. Its automatic
loader is `plugin/so-cmdline-pairs.lua`. Remove that loader and restart to disable.

## Checks

Lua syntax and mocked Neovim API checks passed: alignment/idempotence, alignment
colons, fences, escaped pipes, inline-code pipes, optional outer pipes, Markdown
scope, command pair insertion, closer skipping, pair Backspace, escaped input,
and search-prompt exclusion. Windows terminal interaction has not been tested.
