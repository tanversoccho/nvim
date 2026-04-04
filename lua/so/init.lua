require("so.core")

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
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",

	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

	"https://github.com/saghen/blink.cmp",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-cmdline",
	"https://github.com/saadparwaiz1/cmp_luasnip",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/folke/lazydev.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
}) -- }}}

-- TODO: require('colorizer').setup()

require('todo-comments').setup()

vim.cmd("colorscheme tokyonight-night");

require("oil").setup({ -- {{{
	view_options = {
		show_hidden = true,
	},
	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
})

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
}) -- }}}

require("telescope").setup({ -- {{{
	defaults = {
		sorting_strategy = "ascending",
		layout_config = {
			prompt_position = "top",
		},
	},

	pickers = {
		jumplist = {
			layout_strategy = "vertical",
			layout_config = {
				mirror = true,
				width = 0.62,
			},
		},

		marks = {
			layout_strategy = "vertical",
			layout_config = {
				mirror = true,
				width = 0.62,
			},
		},
		buffers = {
			layout_strategy = "vertical",
			layout_config = {
				mirror = true,
				width = 0.62,
			},
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
		-- zoxide = {
		--   -- your config here
		-- }
	},
}) -- }}}

-- telescope keymap{{{

-- require('telescope').load_extension('luasnip')
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.builtin, { desc = "Telescope" })
vim.keymap.set("n", "<leader>fd", builtin.find_files, { desc = "[F]iles" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[K]eymaps" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[H]elp" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep [W]ord" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live [G]rep" })
vim.keymap.set("n", "<leader>fq", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>ff", builtin.resume, { desc = "telescope [R]esume" })
vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Recent Files" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "buffers" })
vim.keymap.set("n", "<leader>j", builtin.jumplist, { desc = "Jumplist" })
vim.keymap.set("n", "<leader>r", builtin.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>m", builtin.marks, { desc = "Marks" })
vim.keymap.set("n", "<leader>fs", function()
	require("telescope").extensions.luasnip.luasnip()
end, { desc = "[F]ind [S]nippets" })

vim.keymap.set("n", "<leader>f/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[/] in Open Files" })

vim.keymap.set("n", "<leader>fp", function()
  builtin.find_files({
    cwd = vim.fn.stdpath("data") .. "/site/pack/core/opt"
  })
end, { desc = "[P]ackage opt files" })

vim.keymap.set("n", "<leader>fn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[N]vim config files" }) -- }}}

-- lsp config {{{
require("mason").setup()

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
	},
}) -- }}}

