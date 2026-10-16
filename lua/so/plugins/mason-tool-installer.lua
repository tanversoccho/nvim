-- The single installation list for LSP servers, linters, and formatters.
-- Use Mason package names here, not LSP configuration names.
require("mason-tool-installer").setup({
  ensure_installed = {
    "lua-language-server",       -- lua_ls
    "luacheck",                  -- nvim-lint: Lua
    "stylua",                    -- Lua formatter
    "ruff",                      -- Python lint / format / import actions
    "htmlhint",                  -- nvim-lint: HTML
    "eslint-lsp",                -- eslint (project still needs npm dependencies)
    "typescript-language-server", -- ts_ls
    "css-lsp",                   -- cssls
    "powershell-editor-services", -- powershell_es / ScriptAnalyzer
    "ast-grep",                  -- ast_grep; project rules required
    -- Optional: uncomment only the tools you use.
    -- "python-lsp-server",      -- pylsp: Python completion alongside Ruff
    -- "clangd",                 -- C / C++
    -- "markdown-oxide",         -- Markdown
    -- "texlab",                 -- LaTeX
  },
  run_on_start = true,
  start_delay = 1000,
  -- Check for missing tools on every startup, including newly added entries.
  debounce_hours = 0,
  auto_update = false,
  integrations = {
    ["mason-lspconfig"] = false,
    ["mason-null-ls"] = false,
    ["mason-nvim-dap"] = false,
  },
})
-- :MasonToolsInstall installs missing tools now.
-- :MasonToolsUpdate explicitly updates tools.
-- Installation is asynchronous: restart Neovim after first installation.
