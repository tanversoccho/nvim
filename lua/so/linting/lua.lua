local lint = require("lint")
lint.linters_by_ft.lua = { "luacheck" }
-- Recognize Neovim's global; retain upstream stdin and diagnostic parsing.
local args = { "--globals", "vim", "--std", "luajit" }
vim.list_extend(args, lint.linters.luacheck.args)
lint.linters.luacheck.args = args
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } }, telemetry = { enable = false } } },
})
vim.lsp.enable("lua_ls")
