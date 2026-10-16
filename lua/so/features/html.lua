local M = {}
local void = {}
for name in ("area base br col embed hr img input link meta param source track wbr"):gmatch("%S+") do
  void[name] = true
end

-- Lightweight matching, not a full HTML/JavaScript/template parser.
function M.complete(before, after)
  local uncommented = before:gsub("<!%-%-.-%-%->", "")
  if uncommented:find("<!--", 1, true) then return ">" end
  local fragment = before:match("(<[^<]*)$")
  if not fragment then return ">" end
  local tag, rest = fragment:match("^<([%a][%w:_%-]*)(.*)$")
  if not tag or (rest ~= "" and not rest:match("^[%s/]")) then return ">" end
  local quote
  for i = 1, #rest do
    local char = rest:sub(i, i)
    if quote then
      if char == quote then quote = nil end
    elseif char == '"' or char == "'" then
      quote = char
    elseif char == ">" then
      return ">"
    end
  end
  if quote or rest:match("/%s*$") or void[tag:lower()] then return ">" end
  local closing = "</" .. tag .. ">"
  if after:sub(1, #closing):lower() == closing:lower() then return ">" end
  return ">" .. closing .. string.rep("<Left>", #closing)
end

function M.setup()
  if vim.g.so_html_autoclose == nil then vim.g.so_html_autoclose = true end
  local function configure(buf)
    vim.keymap.set("i", ">", function()
      if not vim.g.so_html_autoclose then return ">" end
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      -- Bound scanning work for large files; handles ordinary multiline opening tags.
      local lines = vim.api.nvim_buf_get_lines(0, math.max(0, row - 100), row, false)
      local current = lines[#lines] or ""
      lines[#lines] = current:sub(1, col)
      return M.complete(table.concat(lines, "\n"), current:sub(col + 1))
    end, { buffer = buf, expr = true, desc = "Native HTML closing tag" })
  end
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    group = vim.api.nvim_create_augroup("so-native-html", { clear = true }),
    callback = function(args) configure(args.buf) end,
  })
  if vim.bo.filetype == "html" then configure(vim.api.nvim_get_current_buf()) end
  vim.api.nvim_create_user_command("SoHtmlAutoCloseToggle", function()
    vim.g.so_html_autoclose = not vim.g.so_html_autoclose
    vim.notify("HTML closing tags: " .. (vim.g.so_html_autoclose and "on" or "off"))
  end, { desc = "Toggle native HTML closing tags" })
end
return M
