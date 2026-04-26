
--Options{{{
  --globals
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

  --}}}

  --keymaps{{{

    local map = vim.keymap.set
    -- fire{{{
      map("n", "<Esc>", "<cmd>nohlsearch<CR>")
      map({ "v", "n" }, ":", ";", { desc = "Enter command line" })
      map({ "v", "n" }, ";", ":", { desc = "Repeat f/t motion" })
      map("n", "\\=", function()
        local view = vim.fn.winsaveview()
        vim.cmd("normal! gg=G")
        vim.fn.winrestview(view)
      end, { desc = "Reindent whole file (keep cursor)" })
      -- }}}
      --Window navigation{{{
        map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
        map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
        map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
        map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
        map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
        -- }}}
        map("v", "<", "<gv^")
        map("v", ">", ">gv^")
        -- Move Lines{{{
          map("n", "<A-j>", "<cmd>execute 'move .+' . v:count0<cr>==", { desc = "Move Down" })
          map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
          map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
          map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
          map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
          map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

          map("n", "<A-down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
          map("n", "<A-up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
          map("i", "<A-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
          map("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
          map("v", "<A-down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
          map("v", "<A-up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
          -- }}}

          -- }}}

          -- autocmd {{{
            vim.api.nvim_create_autocmd("TextYankPost", {
              desc = "Highlight when yanking (copying) text",
              group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
              callback = function()
                vim.hl.on_yank()
              end,
            })

            -- show cursorline only in active window enable
            vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
              group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
              callback = function()
                vim.opt_local.cursorline = true
              end,
            })

            -- show cursorline only in active window disable
            vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
              group = "active_cursorline",
              callback = function()
                vim.opt_local.cursorline = false
              end,
            })
            -- Enable inlay hints globally
            vim.lsp.inlay_hint.enable(false)

            -- Auto commands for LSP
            vim.api.nvim_create_autocmd("LspAttach", {
              group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
              callback = function(args)
                -- Ensure inlay hints are enabled for this buffer
                vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
                -- Keymaps
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = args.buf })
              end,
            })
            -- Example: Lua LSP (lua-language-server must be installed)
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "lua",
              callback = function()
                vim.lsp.start({
                  name = "lua_ls",
                  cmd = { "lua-language-server" },
                  root_dir = vim.fs.dirname(vim.fs.find({ ".git", "init.lua" }, { upward = true })[1]),
                  settings = {
                    Lua = {
                      runtime = { version = "LuaJIT" },
                      diagnostics = { globals = { "vim" } },
                      workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                      },
                      telemetry = { enable = false },
                      hint = { enable = true }, -- Enable Lua hints
                    },
                  },
                })
              end,
            })
            -- }}}
