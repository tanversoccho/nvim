local map = vim.keymap
-- map.set("n", "<space>x", ":.lua<CR>")
-- map.set("v", "<space>x", ":lua<CR>")
map.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
map.set("n", "<leader>x", "<cmd>source %<CR>")


map.set('n', '<leader>i', '<cmd>InspectTree<CR>')

map.set("n", "<leader>e", "<cmd>Neotree toggle<CR>")

-- Swap : and ; in Normal mode
map.set({'v','n'}, ':', ';', { desc = 'Enter command line' })
map.set({'v','n'}, ';', ':', { desc = 'Repeat f/t motion' })

map.set("n", "\\=", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { desc = "Reindent whole file (keep cursor)" })

map.set('n', '<leader>q', function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      vim.cmd('lclose')
      return
    end
  end
  vim.diagnostic.setloclist()
end, { desc = 'Toggle diagnostic location list' })

map.set('n', '<leader>Q', function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd('cclose')
      return
    end
  end
  vim.diagnostic.setqflist()
  vim.cmd('copen')
end, { desc = 'Toggle diagnostic quickfix list' })


map.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move Lines
map.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
-- Move Lines
map.set("n", "<A-down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map.set("n", "<A-up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map.set("i", "<A-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
-- map.set("n", "<space>x", ":.lua<CR>")
-- map.set("v", "<space>x", ":lua<CR>")
map.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
map.set("n", "<leader>x", "<cmd>source %<CR>")


map.set('n', '<leader>i', '<cmd>InspectTree<CR>')

map.set("n", "<leader>e", "<cmd>Neotree toggle<CR>")

-- Swap : and ; in Normal mode
map.set({'v','n'}, ':', ';', { desc = 'Enter command line' })
map.set({'v','n'}, ';', ':', { desc = 'Repeat f/t motion' })

map.set("n", "\\=", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { desc = "Reindent whole file (keep cursor)" })

map.set('n', '<leader>q', function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      vim.cmd('lclose')
      return
    end
  end
  vim.diagnostic.setloclist()
end, { desc = 'Toggle diagnostic location list' })

map.set('n', '<leader>Q', function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd('cclose')
      return
    end
  end
  vim.diagnostic.setqflist()
  vim.cmd('copen')
end, { desc = 'Toggle diagnostic quickfix list' })


map.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move Lines
map.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
-- Move Lines
map.set("n", "<A-down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map.set("n", "<A-up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map.set("i", "<A-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
