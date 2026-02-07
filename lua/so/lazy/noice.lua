return
{ -- nvim-notify configuration
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "wrapped-compact",
      timeout = 3000,
      stages = "fade_in_slide_out",
      background_colour = "#000000",
    },
    init = function()
      -- Set as default notify function early to prevent popups during startup
      vim.notify = require("notify")
    end,
  },

  -- noice.nvim configuration
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      -- Your noice.nvim options here
      lsp = {
        -- override markdown rendering for better control
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false,         -- use classic cmdline
        command_palette = true,       -- position cmdline and popupmenu together
        long_message_to_split = true, -- long messages sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,       -- add a border to hover docs and signature help
      },
    },
  }
}
