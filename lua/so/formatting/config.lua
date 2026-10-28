-- Maintain your formatter choices here and style rules in templates/formatting/.
return {
  timeout_ms = 5000,
  -- false: always use your Neovim rule files. true: use each project's rules.
  use_project_config = false,
  -- Optional absolute Prettier JS entrypoint if installed outside Mason/npm.
  prettier_cli = nil,
  formatters = {
    html = "prettier",
    css = "prettier",
    scss = "prettier",
    javascript = "prettier",
    javascriptreact = "prettier",
    typescript = "prettier",
    typescriptreact = "prettier",
    json = "prettier",
    jsonc = "prettier",
    yaml = "prettier",
    python = "ruff",
    lua = "stylua",
    c = "clang-format",
    cpp = "clang-format",
    typst = "typstyle",
    kotlin = "ktfmt", -- Both .kt and .kts use Neovim filetype kotlin.
    sh = "beautysh",
    xml = "xmlformatter",
  },
  -- Only these formatter executables are needed by this feature.
  install = { "prettier", "ruff", "stylua", "clang-format", "typstyle", "ktfmt", "beautysh" },
  beautysh = { indent_size = 2 },
  typstyle = { indent_width = 2, line_width = 100 },
  ktfmt = {
    style = "google", -- "kotlinlang": 4-space blocks; "google": 2-space blocks.
    jar = nil, -- Optional absolute path; otherwise find Mason's ktfmt JAR.
    java = nil, -- Optional java.exe path; otherwise JAVA_HOME, then PATH.
    timeout_ms = 15000, -- Allow for JVM startup without changing other formatters.
  },
  xmlformatter = { indent_size = 2 },
  -- Optional cleanup: only :SoFormatToolsClean uninstalls these packages.
  -- Language servers and your current Lua/HTML linters are preserved.
  retire = {
    "black",
    "darker",
    "csskit",
    "eslint_d",
    "fixjson",
    "latexindent",
    "markdown-toc",
    "markdownlint",
    "markdownlint-cli2",
    "pydocstyle",
    "vale",
  },
}
