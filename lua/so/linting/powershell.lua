-- PowerShell Editor Services exposes PSScriptAnalyzer diagnostics through LSP.
-- Uses Mason's default installation directory; adjust if you customized it.
vim.lsp.config("powershell_es", {
  bundle_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "powershell-editor-services"),
  settings = { powershell = { scriptAnalysis = { enable = true } } },
})
vim.lsp.enable("powershell_es")
