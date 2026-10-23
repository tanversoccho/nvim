vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 4
vim.g.netrw_keepdir = 1
vim.keymap.set("n", "<leader>ee", "<cmd>Lexplore<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "-", function()
  local path = vim.api.nvim_buf_get_name(0)
  local dir = path ~= "" and vim.fn.fnamemodify(path, ":p:h") or vim.fn.getcwd()
  vim.cmd("Explore " .. vim.fn.fnameescape(dir))
end, { desc = "Explore current file directory" })
