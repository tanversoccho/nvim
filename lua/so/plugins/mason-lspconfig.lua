-- Mason must be configured before the LSP bridge, regardless of loader order.
require("so.plugins.mason")

-- Neovim supplies completion/snippet capabilities; no completion plugin required.
vim.lsp.config("*", { capabilities = vim.lsp.protocol.make_client_capabilities() })

local servers = {
  lua_ls = {
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
  },
  clangd = {},
  pyright = {},
  tinymist = { settings = { formatterMode = "typstyle" } },
  cssls = {},
  html = {},
  ast_grep = {
    filetypes = {
      "javascript", "typescript", "javascriptreact",
      "typescriptreact", "html", "css",
    },
  },
  ts_ls = {},
}
for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

require("mason-lspconfig").setup({
  -- Installation belongs exclusively to mason-tool-installer.
  ensure_installed = {},
  -- Preserve the existing behavior: enable servers installed through Mason.
  automatic_enable = { "lua_ls", "clangd", "pyright", "tinymist", "ts_ls", "cssls", "html", "ruff", "eslint", "powershell_es" },
})
-- Language-specific linting modules can still extend these named configs.
