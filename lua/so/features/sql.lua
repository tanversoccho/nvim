local M = {}
function M.setup()
  local function configure(buf)
    vim.api.nvim_buf_call(buf, function()
      -- The space typed after sf triggers expansion and supplies the trailing space.
      vim.cmd("inoreabbrev <buffer> sf select * from")
    end)
  end
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    group = vim.api.nvim_create_augroup("so-native-sql", { clear = true }),
    callback = function(args) configure(args.buf) end,
  })
  if vim.bo.filetype == "sql" then configure(vim.api.nvim_get_current_buf()) end
end
return M
