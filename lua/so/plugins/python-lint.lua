-- Python diagnostics, formatting, and import actions through native Ruff LSP.
-- Install the executable first: :MasonInstall ruff
vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  init_options = { settings = {} },
})
vim.lsp.enable("ruff")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  group = vim.api.nvim_create_augroup("so-python-lint", { clear = true }),
  callback = function(args)
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({
        bufnr = args.buf,
        async = false,
        timeout_ms = 3000,
        filter = function(client) return client.name == "ruff" end,
      })
    end, { buffer = args.buf, desc = "Python: format with Ruff" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
      { buffer = args.buf, desc = "Python: code actions / organize imports" })
  end,
})
