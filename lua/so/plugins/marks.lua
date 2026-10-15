require("marks").setup({ builtin_marks = {} })
vim.keymap.set("n", "<leader>um", "<cmd>MarksToggleSigns<CR>", { desc = "Toggle mark signs", silent = true })
