-- Neovim native LSP configuration (0.12+).
-- Server-specific overrides live in after/lsp/<server>.lua.
-- nvim-lspconfig provides default server definitions on runtimepath.
-- Mason must be initialized before this file (see so.plugins.init).

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Enabling a server does not install it. Mason's tool installer handles tools.
vim.lsp.enable({
  "lua_ls",
  "clangd",
  "pyright",
  "ruff",
  "tinymist",
  "ts_ls",
  "eslint",
  "cssls",
  "html",
})
