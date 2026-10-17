local M = {}
local original = {}

function M.refresh()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_win_call(win, function()
      local chars = vim.opt_local.listchars:get()
      if vim.bo.buftype == "" and vim.g.so_indent_guides then
        if not original[win] then
          original[win] = {
            tab = chars.tab,
            leadmultispace = chars.leadmultispace,
            list = vim.wo.list,
          }
        end
        local width = vim.bo.shiftwidth
        if width == 0 then width = vim.bo.tabstop end
        width = math.max(1, width)
        chars.leadmultispace = "│" .. string.rep(" ", width - 1)
        -- One vertical marker at each tab's start, blank padding thereafter.
        chars.tab = "│ "
        vim.opt_local.listchars = chars
        vim.wo.list = true
      elseif original[win] then
        local saved = original[win]
        chars.tab, chars.leadmultispace = saved.tab, saved.leadmultispace
        vim.opt_local.listchars = chars
        vim.wo.list = saved.list
        original[win] = nil
      end
    end)
  end
end

function M.setup()
  if vim.g.so_indent_guides == nil then vim.g.so_indent_guides = true end
  local group = vim.api.nvim_create_augroup("so-native-indent", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
    group = group, callback = M.refresh,
  })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = group, pattern = { "shiftwidth", "tabstop" }, callback = M.refresh,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    callback = function(args) original[tonumber(args.match)] = nil end,
  })
  vim.api.nvim_create_user_command("SoIndentToggle", function()
    vim.g.so_indent_guides = not vim.g.so_indent_guides
    M.refresh()
  end, { desc = "Toggle native indentation guides" })
  M.refresh()
end
return M
