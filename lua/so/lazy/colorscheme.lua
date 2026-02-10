return {
  -- Rose Pine (Keeping it installed as a backup)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({})
    end,
  },

  -- Tokyo Night (Main Colorscheme)
  {
    "folke/tokyonight.nvim",
    lazy = false, -- Load during startup
    priority = 1000, -- Load before other plugins
    opts = {
      style = "night",          -- Use the "night" variant
      transparent = true,       -- Make the main editor background transparent
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
