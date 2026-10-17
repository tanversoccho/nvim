-- Maintain your formatter choices here and style rules in templates/formatting/.
return {
  timeout_ms = 5000,
  -- false: always use your Neovim rule files. true: use each project's rules.
  use_project_config = false,
  -- Optional absolute Prettier JS entrypoint if installed outside Mason/npm.
  prettier_cli = nil,
  formatters = {
    html = "prettier", css = "prettier", scss = "prettier",
    javascript = "prettier", javascriptreact = "prettier",
    typescript = "prettier", typescriptreact = "prettier",
    json = "prettier", jsonc = "prettier", yaml = "prettier",
    python = "ruff", lua = "stylua",
  },
  -- Only these formatter executables are needed by this feature.
  install = { "prettier", "ruff", "stylua" },
  -- Optional cleanup: only :SoFormatToolsClean uninstalls these packages.
  -- Language servers and your current Lua/HTML linters are preserved.
  retire = {
    "black", "darker", "csskit", "eslint_d", "fixjson", "latexindent",
    "markdown-toc", "markdownlint", "markdownlint-cli2", "pydocstyle", "vale",
  },
}
