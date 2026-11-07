local opt = vim.opt_local

-- Disable legacy SQLComplete/dbext integration
vim.bo.omnifunc = ""
vim.bo.completefunc = ""

-- Keep native completion, but exclude SQL omni completion
vim.opt_local.complete:remove("o")
vim.opt_local.complete:remove("F")

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.colorcolumn = "100"
opt.omnifunc = ""

-- SQL abbreviations only in this buffer
vim.cmd.inoreabbrev("<buffer> sf select * from")
