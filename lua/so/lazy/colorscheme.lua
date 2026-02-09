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
      on_colors = function(c)
        c.bg_statusline = "#000000"
      end,
      -- 2. Override specific highlight groups for the tabline
      on_highlights = function(hl, c)
        hl.TabLine = { bg = "#000000", fg = c.fg_dark }
        hl.TabLineFill = { bg = "#000000" }
        hl.TabLineSel = { bg = "#24283b", fg = c.fg } -- Active tab slightly lighter for visibility
        -- Fix cursor line transparency if it's still too faint
        hl.CursorLine = { bg = "#1a1b26" }
      end,    },
      config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd.colorscheme("tokyonight-night")
      end,
    },
  }
