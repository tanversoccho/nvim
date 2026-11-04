local map = vim.keymap.set

-- normal keymap
map({ "v", "n" }, ":", ";", { desc = "Enter command line" })
map({ "v", "n" }, ";", ":", { desc = "Repeat f/t motion" })

-- ui
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- formatter
map("n", "\\=", "<cmd>SoFormat<CR>", { desc = "Format current file", })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- moving though window
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- better indent making
map("v", "<", "<gv^")
map("v", ">", ">gv^")
map("n", "<leader>l", "<cmd>LazyGit<CR>" , { desc = "Open LazyGit" })

-- moving window using jk
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count0<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- moving window using up down arrow
map("n", "<A-down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map( "v", "<A-up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
