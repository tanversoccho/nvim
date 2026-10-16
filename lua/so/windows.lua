if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  if vim.fn.executable("pwsh.exe") == 1 then
    vim.o.shell = "pwsh.exe"
    vim.o.shellcmdflag = "-NoProfile -c"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
    vim.opt.shellredir = '>%s 2>&1'
  end
  -- Preserve TERM from the terminal; never force it to "dumb".
end
