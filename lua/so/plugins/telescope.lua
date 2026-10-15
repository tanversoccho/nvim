local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local map = vim.keymap.set

-- No compiled extensions required: works with the existing vim.pack packages.
telescope.setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      width = 0.92,
      height = 0.85,
      horizontal = { preview_width = 0.55 },
      vertical = { preview_height = 0.45 },
      flex = { flip_columns = 120 },
    },
    path_display = { "truncate" },
    file_ignore_patterns = { "^%.git/", "/%.git/", "^%.git\\", "\\%.git\\" },
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
      n = { ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist },
    },
  },
  pickers = {
    find_files = { hidden = true },
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
      mappings = {
        i = { ["<C-x>"] = actions.delete_buffer },
        n = { ["<C-x>"] = actions.delete_buffer },
      },
    },
    oldfiles = { only_cwd = true },
    live_grep = { additional_args = { "--hidden", "--glob", "!.git/*" } },
    grep_string = { additional_args = { "--hidden", "--glob", "!.git/*" } },
  },
})

local function bind(lhs, fn, desc)
  map("n", lhs, fn, { desc = desc })
end
local function with_rg(fn)
  return function()
    if vim.fn.executable("rg") ~= 1 then
      vim.notify("Telescope text search requires ripgrep (rg).", vim.log.levels.WARN)
      return
    end
    fn()
  end
end
bind("<leader><leader>", builtin.builtin, "Telescope pickers")
bind("<leader>fd", builtin.find_files, "Find files (including dotfiles)")
bind("<leader>fk", builtin.keymaps, "Find keymaps")
bind("<leader>fh", builtin.help_tags, "Find help")
bind("<leader>fw", with_rg(builtin.grep_string), "Find word under cursor")
bind("<leader>fg", with_rg(builtin.live_grep), "Live grep")
bind("<leader>fq", builtin.diagnostics, "Find diagnostics")
bind("<leader>ff", builtin.resume, "Resume last picker")
bind("<leader>f.", builtin.oldfiles, "Recent files in current directory")
bind("<leader>b", builtin.buffers, "Find buffers")
bind("<leader>j", builtin.jumplist, "Find jumps")
bind("<leader>r", builtin.registers, "Find registers")
bind("<leader>m", builtin.marks, "Find marks")
-- Replaces the missing LuaSnip Telescope extension mapping.
bind("<leader>fs", builtin.lsp_document_symbols, "Find document symbols")
bind("<leader>fR", builtin.lsp_references, "Find LSP references")
bind("<leader>fc", builtin.commands, "Find commands")
bind("<leader>ft", builtin.colorscheme, "Find themes")
bind("<leader>/", builtin.current_buffer_fuzzy_find, "Search current buffer")
bind("<leader>f/", with_rg(function()
  builtin.live_grep({ grep_open_files = true, prompt_title = "Grep Open Files" })
end), "Grep open files")
bind("<leader>fH", function()
  builtin.find_files({ hidden = true, no_ignore = true, prompt_title = "All Files (Hidden + Ignored)" })
end, "Find hidden and ignored files")
bind("<leader>fn", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config"), prompt_title = "Neovim Config" })
end, "Find Neovim config files")
bind("<leader>fp", function()
  local path = vim.fn.stdpath("data") .. "/site/pack/core/opt"
  if vim.fn.isdirectory(path) ~= 1 then
    vim.notify("Native package directory does not exist yet: " .. path, vim.log.levels.WARN)
    return
  end
  builtin.find_files({ cwd = path, prompt_title = "Native Package Files" })
end, "Find package files")
