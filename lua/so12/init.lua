--Options{{{

--globals
vim.g.mapleader = ' '
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true
--global fix
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Styles
-- vim.go.statusline = "FILE %t %m %= |%Y|%l,%v"
--basic options
vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.showmode = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.wildmenu = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.confirm = true
vim.opt.list = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.winborder = 'rounded'
vim.opt.pumborder = "rounded"
vim.opt.path:append("**")
vim.opt.wildoptions = { "pum", "fuzzy" }
vim.opt.wildmode = "noselect:full"

vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.isfname:append(":")
vim.opt.listchars = {
  tab = '→ ',      -- Use arrow for tabs
  trail = '•',     -- Bullet point for trailing spaces
  nbsp = '␣',      -- Open box for non-breaking spaces
  extends = '↪',   -- Line wrap indicator
  precedes = '↩',  -- Line wrap indicator
}
vim.opt.inccommand = 'split'
vim.opt.foldmethod = "marker"
vim.opt.completeopt = 'menu,menuone,noselect'

--}}}
--keymaps{{{

local map = vim.keymap
-- fire{{{
map.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
map.set({'v','n'}, ':', ';', { desc = 'Enter command line' })
map.set({'v','n'}, ';', ':', { desc = 'Repeat f/t motion' })
map.set("n", "\\=", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { desc = "Reindent whole file (keep cursor)" })
-- }}}
--Window navigation{{{
map.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- }}}
-- Move Lines{{{
map.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map.set("n", "<A-down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map.set("n", "<A-up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map.set("i", "<A-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map.set("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map.set("v", "<A-down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map.set("v", "<A-up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
-- }}}

-- }}}
-- autocmd {{{
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
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

-- }}}
-- packages{{{
vim.pack.add({
  "https://github.com/rose-pine/neovim",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/selimacerbas/markdown-preview.nvim",
  "https://github.com/OXY2DEV/markview.nvim",
  "https://github.com/lervag/vimtex",
  "https://github.com/kdheepak/lazygit.nvim",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/kristijanhusak/vim-dadbod-completion",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/norcalli/nvim-colorizer.lua",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-cmdline",
  "https://github.com/saadparwaiz1/cmp_luasnip",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/folke/lazydev.nvim",
}) -- }}}
-- require('colorizer').setup()
require("oil").setup({-- {{{
  view_options = {
    show_hidden = true,
  },
  map.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
})-- }}}
require('telescope').setup({-- {{{
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = 'top',
    },
  },

  pickers = {
    jumplist = {
      layout_strategy = 'vertical',
      layout_config = {
        mirror = true,
        width = 0.62,
      },
    },

    marks = {
      layout_strategy = 'vertical',
      layout_config = {
        mirror = true,
        width = 0.62,
      },
    },
    buffers = {
      layout_strategy = 'vertical',
      layout_config = {
        mirror = true,
        width = 0.62,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    -- zoxide = {
      --   -- your config here
      -- }
    },
  })-- }}}
-- telescope keymap{{{
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', builtin.builtin, { desc = 'Telescope' })
vim.keymap.set('n', '<leader>fd', builtin.find_files, { desc = '[F]iles' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[K]eymaps' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[H]elp' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Grep [W]ord' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live [G]rep' })
vim.keymap.set('n', '<leader>fq', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>ff', builtin.resume, { desc = 'telescope [R]esume' })
vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'buffers' })
vim.keymap.set('n', '<leader>j', builtin.jumplist, { desc = 'Jumplist' })
vim.keymap.set('n', '<leader>r', builtin.registers, { desc = 'Registers' })
vim.keymap.set('n', '<leader>m', builtin.marks, { desc = 'Marks' })
vim.keymap.set('n', '<leader>fs', function()
  require('telescope').extensions.luasnip.luasnip()
end, { desc = '[F]ind [S]nippets' })

vim.keymap.set('n', '<leader>f/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[/] in Open Files' })

vim.keymap.set('n', '<leader>fn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[N]vim config files' })-- }}}
require("mason").setup()-- {{{

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
  }
})-- }}}
