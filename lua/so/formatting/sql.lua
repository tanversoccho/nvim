-- Default SQL Formatter rules for the unified formatter.
-- See: https://github.com/sql-formatter-org/sql-formatter
-- Indentation is set dynamically from the current buffer in init.lua.
return {
  language = "sql", -- Change to "postgresql", "mysql", "sqlite", etc.
  keywordCase = "upper",
  dataTypeCase = "upper",
  functionCase = "upper",
  linesBetweenQueries = 2,
  logicalOperatorNewline = "before",
}
