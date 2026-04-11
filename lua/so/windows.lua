vim.o.shell = "pwsh.exe"
vim.o.shellcmdflag = "-ExecutionPolicy Bypass -NoProfile -c"
vim.o.shellquote = ""
vim.o.shellxquote = ""

-- Add this line to make the terminal ignore the formatting junk
vim.opt.shellredir = '>%s 2>&1'
