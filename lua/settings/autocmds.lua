-- NOTE: might change later 
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = "active_cursorline",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
-- Enable inlay hints globally
vim.lsp.inlay_hint.enable(false)

-- Auto commands for LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(args)
    -- Ensure inlay hints are enabled for this buffer
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf })
    -- Keymaps
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = args.buf })
  end,
})

-- NOTE: might change later 
vim.api.nvim_create_user_command("Cpwd", function()
  local bufpath = vim.api.nvim_buf_get_name(0)
  if bufpath == "" then
    vim.notify("Buffer is unnamed", vim.log.levels.WARN)
    return
  end

  local dir
  if vim.fn.isdirectory(bufpath) == 1 then
    dir = vim.fn.fnamemodify(bufpath, ":p")
  else
    dir = vim.fn.fnamemodify(bufpath, ":p:h")
  end

  dir = vim.fn.resolve(dir)

  if vim.fn.isdirectory(dir) == 0 then
    vim.notify("Not a valid directory: " .. dir, vim.log.levels.ERROR)
    return
  end

  vim.cmd.cd(vim.fn.fnameescape(dir))
  vim.notify("cwd → " .. vim.fn.getcwd(), vim.log.levels.INFO)
end, { desc = "cd to current buffer's directory" })
