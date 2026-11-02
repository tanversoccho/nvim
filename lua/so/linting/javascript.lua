-- Uses nvim-lspconfig's ESLint defaults, including configuration detection.
-- Each JS/TS project must install ESLint and provide eslint.config.*.
vim.lsp.config("eslint", {
  settings = { workingDirectory = { mode = "auto" } },
})
vim.lsp.enable("eslint")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  group = vim.api.nvim_create_augroup("so-eslint-actions", { clear = true }),
  callback = function(args)
    vim.keymap.set(
      "n",
      "<leader>ca",
      vim.lsp.buf.code_action,
      { buffer = args.buf, desc = "ESLint / LSP code actions" }
    )
  end,
})
