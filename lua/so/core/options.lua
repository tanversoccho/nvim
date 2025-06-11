vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

-- vim.opt.termguicolor = true

-- local group = vim.api.nvim_create_augroup("RelativeNumberCurrentBuffer", { clear = true })

-- -- Enable relative number for current buffer
-- vim.api.nvim_create_autocmd("BufEnter", {
--     group = group,
--     callback = function()
--         vim.opt_local.relativenumber = true
--     end,
-- })
--
-- -- Disable relative number when leaving buffer
-- vim.api.nvim_create_autocmd("BufLeave", {
--     group = group,
--     callback = function()
--         vim.opt_local.relativenumber = false
--     end,
-- })
--
vim.o.mouse = 'a'

vim.o.showmode = false

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'

vim.o.confirm = true

-- Completion menu settings
vim.opt.completeopt = 'menu,menuone,noselect'  -- Always show completion menu

vim.opt.isfname:append(":")

