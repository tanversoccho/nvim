vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true
--global fix
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Styles
-- vim.go.statusline = "FILE %t %m %= |%Y|%l,%v"
--basic options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.breakindent = true
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.showmode = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.autocomplete = true
vim.opt.undofile = true
vim.opt.wildmenu = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
vim.opt.path:append("**")
vim.opt.wildoptions = { "pum", "fuzzy" }
vim.opt.wildmode = "noselect:full"

vim.opt.signcolumn = "yes"
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.scrolloff = 99
vim.opt.tabstop = 2
vim.opt.timeoutlen = 300
vim.opt.updatetime = 250

vim.opt.isfname:append(":")
vim.opt.listchars = {
  tab = "→ ", -- Use arrow for tabs
  trail = "•", -- Bullet point for trailing spaces
  nbsp = "␣", -- Open box for non-breaking spaces
  extends = "↪", -- Line wrap indicator
  precedes = "↩", -- Line wrap indicator
}
vim.opt.inccommand = "split"
vim.opt.foldmethod = "marker"
vim.opt.completeopt = "menu,menuone,noselect"

-- Enable diagnostic signs in gutter
vim.diagnostic.config({
  virtual_text = true, -- Shows warnings inline
  signs = true, -- Shows icons in gutter
  underline = true, -- Underlines the issue
  update_in_insert = false,
  severity_sort = true,
})
-- Set diagnostic symbols (optional but nice)
vim.fn.sign_define("DiagnosticSignError", { text = "✘", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

