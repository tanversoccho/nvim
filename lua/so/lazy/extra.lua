return {
  {
    "OXY2DEV/markview.nvim", lazy = false,
  },
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- Use the generic viewer (required for SumatraPDF on Windows)
      vim.g.vimtex_view_method = "general"

      -- Path to SumatraPDF executable
      vim.g.vimtex_view_general_viewer = "SumatraPDF.exe"

      -- Viewer options: reuse window + forward search
      -- @pdf = PDF file, @tex = source, @line = current line
      vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"

      -- Compiler configuration (latexmk)
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-file-line-error"
        },
      }
    end,
  },
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
      view_options = {
        show_hidden = true,  -- This shows hidden files (like .config, .gitignore)
      },
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
