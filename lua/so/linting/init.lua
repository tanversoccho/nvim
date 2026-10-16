-- Native LSP handles Ruff, ESLint and PowerShell analysis.
-- nvim-lint runs the extra Lua/HTML command-line linters.
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
local lint = require("lint")
local languages = { "python", "lua", "html", "javascript", "powershell" }
for _, name in ipairs(languages) do
  require("so.linting." .. name)
end

local function run(manual)
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "" or vim.api.nvim_buf_get_name(buf) == "" then return end
  local available, missing = {}, {}
  for _, name in ipairs(lint.linters_by_ft[vim.bo[buf].filetype] or {}) do
    local definition = lint.linters[name]
    local cmd = type(definition.cmd) == "function" and definition.cmd() or definition.cmd
    if vim.fn.executable(cmd) == 1 then
      table.insert(available, name)
    else
      table.insert(missing, cmd)
    end
  end
  if #available > 0 then
    -- Resolve each buffer's project, rather than running from Neovim's config folder.
    local cwd = vim.fs.root(buf, { ".luacheckrc", ".htmlhintrc", "package.json", ".git" })
      or vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
    lint.try_lint(available, { cwd = cwd })
  end
  if manual then
    if #missing > 0 then
      vim.notify("Missing linter executables: " .. table.concat(missing, ", "), vim.log.levels.WARN)
    elseif #available == 0 then
      vim.notify("This filetype uses LSP diagnostics. Check :checkhealth vim.lsp.")
    end
  end
end
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("so-linting", { clear = true }),
  callback = function() run(false) end,
})
vim.api.nvim_create_user_command("SoLint", function() run(true) end,
  { desc = "Run command-line linters for this buffer" })
vim.keymap.set("n", "<leader>cl", "<cmd>SoLint<CR>", { desc = "Run linters" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })
