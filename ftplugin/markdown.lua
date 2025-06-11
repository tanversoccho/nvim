-- In your markview setup


vim.opt_local.makeprg = 'pandoc "%" -o "%:r.pdf" --css "style.css" --pdf-engine wkhtmltopdf'
-- Toggle Markdown Preview
vim.keymap.set("n", "<leader>x", "<cmd>MarkdownPreviewToggle<CR>", {
  buffer = true,
  desc = "Toggle Markdown Preview"
})
