local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
                        "javascript",
                        "typescript",
                        "javascriptreact",
                        "typescriptreact",
                        "html",
                        "css",
                },
        },
        ts_ls = {},
}
require("mason-lspconfig").setup({

        handlers = {
                function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = capabilities
                        require("lspconfig")[server_name].setup(server)
                end,
        },
}) -- }}}
