--Options{{{

--globals{{{
vim.g.mapleader = ' '
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true
-- }}}
-- Styles{{{
-- vim.go.statusline = "FILE %t %m %= |%Y|%l,%v"
vim.o.showmode = true
vim.opt.termguicolors = true
-- }}}
--global fix{{{
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
-- }}}
--basic options{{{
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
-- }}}
vim.o.mouse = 'a'
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.o.breakindent = true
vim.o.undofile = true

-- Search Settings
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true

--Tabbing / Indentation{{{
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- }}}
vim.o.list = true
vim.opt.listchars = {
  tab = '→ ',      -- Use arrow for tabs
  trail = '•',     -- Bullet point for trailing spaces
  nbsp = '␣',      -- Open box for non-breaking spaces
  extends = '↪',   -- Line wrap indicator
  precedes = '↩',  -- Line wrap indicator
}
vim.o.inccommand = 'split'
vim.o.confirm = true

-- Completion menu settings{{{
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.isfname:append(":")
-- }}}
-- Fold settings{{{
vim.opt.foldmethod = "marker"
-- }}}
-- }}}
--keymaps{{{

local map = vim.keymap
-- fire{{{
map.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
map.set({'v','n'}, ':', ';', { desc = 'Enter command line' })
map.set({'v','n'}, ';', ':', { desc = 'Repeat f/t motion' })
map.set("n", "\\=", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { desc = "Reindent whole file (keep cursor)" })
-- }}}
--Window navigation{{{
map.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- }}}
-- Move Lines{{{
map.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map.set("n", "<A-down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map.set("n", "<A-up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map.set("i", "<A-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
-- }}}

-- }}}
-- autocmd {{{
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
-- }}}
-- plugins{{{

-- packages{{{
vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/rose-pine/neovim",
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/norcalli/nvim-colorizer.lua',
})
-- }}}
-- setup {{{

-- oil {{{
require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  map.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
})
-- }}}
-- require('colorizer').setup()

-- }}}

-- }}}
