-- Use Blink as the completion engine; do not also configure nvim-cmp.setup().
vim.opt.autocomplete = false
require("blink.cmp").setup({
  keymap = { preset = "default" },
  -- Works on Windows without downloading/building a native matcher.
  fuzzy = { implementation = "lua" },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  snippets = { preset = "default" },
})
