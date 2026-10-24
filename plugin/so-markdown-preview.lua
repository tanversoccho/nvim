-- Your own Markdown feature, automatically loaded by Neovim.
require("so.features.markdown").setup({
  enabled = true,
  hide_cursor_line = true,
  code_blocks = true,
  code_labels = true,
  checkboxes = true,
  headings = true,
  inline_code = true,
  links = true,
  debounce_ms = 60,
  max_lines = 20000,
})
