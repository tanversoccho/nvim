local opt = vim.opt_local

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.colorcolumn = "100"

-- SQL abbreviations only in this buffer
vim.cmd.inoreabbrev("<buffer> sf select * from")
