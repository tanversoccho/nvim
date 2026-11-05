-- Conform.nvim, managed by native vim.pack (no lazy.nvim).
-- Old custom formatter is not loaded. :SoFormat / <leader>cf remain available.
local conform = require("conform")

local function indent(buf)
  local sw = vim.bo[buf].shiftwidth
  local ts = vim.bo[buf].tabstop
  return (sw > 0 and sw or ts), vim.bo[buf].expandtab
end

local function sql_args(_, ctx)
  local buf = ctx.buf or vim.api.nvim_get_current_buf()
  local width, spaces = indent(buf)
  local opts = vim.tbl_deep_extend("force", {
    language = "sqlite",
    keywordCase = "upper",
    dataTypeCase = "upper",
    functionCase = "upper",
    linesBetweenQueries = 2,
    logicalOperatorNewline = "before",
  }, vim.b[buf].so_sql_format or {})
  opts.tabWidth = width
  opts.useTabs = not spaces
  return { "--config", vim.json.encode(opts) }
end

local function sql_cli()
  -- Mason's SQL Formatter is a Node.js CLI. Avoid Windows .cmd shims.
  local cli = vim.fs.joinpath(
    vim.fn.stdpath("data"), "mason", "packages", "sql-formatter",
    "node_modules", "sql-formatter", "bin", "sql-formatter-cli.cjs"
  )
  if vim.fn.filereadable(cli) == 1 then
    return vim.fn.exepath("node") ~= "" and vim.fn.exepath("node") or "node"
  end
  -- When the Mason path isn't present use the normal executable.
  return "sql-formatter"
end

local function sql_command_args(_, ctx)
  local cli = vim.fs.joinpath(
    vim.fn.stdpath("data"), "mason", "packages", "sql-formatter",
    "node_modules", "sql-formatter", "bin", "sql-formatter-cli.cjs"
  )
  local args = sql_args(nil, ctx)
  if vim.fn.filereadable(cli) == 1 then
    table.insert(args, 1, cli)
  end
  return args
end

conform.setup({
  -- Explicit formatting only: no automatic changes when saving.
  format_on_save = nil,
  notify_on_error = true,
  default_format_opts = { timeout_ms = 10000, lsp_format = "never" },
  formatters_by_ft = {
    lua = { "stylua" },
    luau = { "stylua" },
    python = { "ruff_format" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    java = { "clang-format" },
    kotlin = { "ktfmt" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    sh = { "beautysh" },
    bash = { "beautysh" },
    zsh = { "beautysh" },
    ksh = { "beautysh" },
    csh = { "beautysh" },
    sql = { "sql_formatter" },
    typst = { "typstyle" },
    xml = { "xmlformatter" },
    groovy = { "npm-groovy-lint" },
  },
  formatters = {
    prettier = {
      prepend_args = function(_, ctx)
        local width, spaces = indent(ctx.buf)
        return { "--tab-width", tostring(width), spaces and "--no-use-tabs" or "--use-tabs" }
      end,
    },
    stylua = {
      append_args = function(_, ctx)
        local width, spaces = indent(ctx.buf)
        return { "--indent-type", spaces and "Spaces" or "Tabs", "--indent-width", tostring(width) }
      end,
    },
    ruff_format = {
      append_args = function(_, ctx)
        local width, spaces = indent(ctx.buf)
        return {
          "--config", "indent-width=" .. width,
          "--config", 'format.indent-style="' .. (spaces and "space" or "tab") .. '"',
        }
      end,
    },
    sql_formatter = {
      inherit = false,
      command = sql_cli,
      args = sql_command_args,
      stdin = true,
    },
  },
})

local function format(buf)
  conform.format({ bufnr = buf or 0, async = false, timeout_ms = 10000, lsp_format = "never" })
end

vim.api.nvim_create_user_command("SoFormat", function()
  format(0)
end, { desc = "Format buffer with conform.nvim" })

vim.api.nvim_create_user_command("SoFormatInfo", function()
  vim.cmd("ConformInfo")
end, { desc = "Show Conform formatter availability and log" })

vim.keymap.set("n", "<leader>cf", function()
  format(0)
end, { desc = "Format current file (Conform)" })
