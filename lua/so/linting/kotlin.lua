-- Kotlin style diagnostics using your existing nvim-lint setup.
-- Install the external tool with :MasonInstall ktlint
local lint = require("lint")

lint.linters_by_ft.kotlin = { "ktlint" }
