-- Ruff supplies diagnostics/actions; Pyright supplies completion and types.
vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})
vim.lsp.enable("ruff")
