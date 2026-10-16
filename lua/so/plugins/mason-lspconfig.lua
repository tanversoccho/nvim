-- Mason must be configured before the LSP bridge, regardless of loader order.
require("so.plugins.mason")

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Use Blink's capabilities when available; no dependency on cmp-nvim-lsp.
local ok, blink = pcall(require, "blink.cmp")
if ok then capabilities = blink.get_lsp_capabilities(capabilities) end
vim.lsp.config("*", { capabilities = capabilities })

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
  automatic_enable = true,
})
-- Language-specific linting modules can still extend these named configs.
