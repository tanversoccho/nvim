if not vim.pack or type(vim.pack.add) ~= "function" then
  error("This configuration requires Neovim 0.12+ with vim.pack")
end

vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/chentoast/marks.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/kdheepak/lazygit.nvim",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  -- "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/norcalli/nvim-colorizer.lua",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/tpope/vim-dadbod",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})
