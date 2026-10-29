-- The ONLY automatic installation list. Names are Mason package names.
require("mason-tool-installer").setup({
  ensure_installed = {
    "lua-language-server", "luacheck", "stylua",
    "clangd", "clang-format",
    "typescript-language-server", "eslint-lsp", "prettier",
    "tinymist", "typstyle",
    "pyright", "ruff",
    "html-lsp", "htmlhint", "css-lsp", "powershell-editor-services",
    "debugpy", "codelldb", "js-debug-adapter", "local-lua-debugger-vscode",
  },
  run_on_start = true,
  start_delay = 1000,
  debounce_hours = 24, -- Avoid repeated tool checks in every editing session.
  auto_update = false,
  integrations = {
    ["mason-lspconfig"] = false,
    ["mason-null-ls"] = false,
    ["mason-nvim-dap"] = false,
  },
})
