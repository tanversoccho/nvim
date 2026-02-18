return {
  {
    "OXY2DEV/markview.nvim", lazy = false,
  },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   build = "cd app && yarn install",
  --   init = function()
  --     vim.g.mkdp_filetypes = { "markdown" }
  --   end,
  --   ft = { "markdown" },
  -- },
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        -- all optional; sane defaults shown
        port = 8421,
        open_browser = true,
        debounce_ms = 300,
      })
    end,
  },
  { "folke/todo-comments.nvim", opts = {} },
  { "nvim-lua/plenary.nvim",    lazy = true },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    opts = {},
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  { "kdheepak/lazygit.nvim" },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require("mini.pairs").setup()
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {
      hidden = true,
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      preset = "helix",
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        window = {
          position = "right",
        },
      })
    end,
  }
}
