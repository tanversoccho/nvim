vim.opt.hidden = true -- Keep unsaved files in background buffers.
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
vim.g.netrw_preview = 1 -- Vertical preview.
vim.g.netrw_alto = 0    -- Preview on the left.
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

local function explore_here()
  local filename = vim.api.nvim_buf_get_name(0)
  local directory

  if vim.bo.filetype == "netrw" then
    directory = vim.b.netrw_curdir or vim.fn.getcwd()
  elseif filename ~= "" then
    directory = vim.fn.fnamemodify(filename, ":p:h")
  else
    directory = vim.fn.getcwd()
  end

  vim.cmd("edit " .. vim.fn.fnameescape(directory))
end

vim.keymap.set("n", "-", explore_here, {
  desc = "Explore current directory",
})
