-- Neovim 0.12 native LSP setup (without mason-lspconfig.nvim).
-- nvim-lspconfig supplies server definitions in its lsp/ directory.
-- Mason is configured earlier in so.plugins.init and adds its bin/ to PATH.

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      completion = { callSnippet = "Replace" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath("config") .. "/lua",
        },
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("tinymist", {
  settings = { formatterMode = "typstyle" },
})

-- These names match the configs provided by nvim-lspconfig.
-- A server starts only when its executable is available and its
-- filetype/workspace conditions are satisfied.
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
  "powershell_es",
})
