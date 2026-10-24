local M = {}
local function context()
  local line, pos = vim.fn.getcmdline(), vim.fn.getcmdpos()
  return line:sub(1, pos - 1), line:sub(pos)
end
local function escaped(before)
  return #(before:match("(\\+)$") or "") % 2 == 1
end
function M.setup()
  for opening, closing in pairs({ ["("] = ")", ['"'] = '"' }) do
    vim.keymap.set("c", opening, function()
      if vim.fn.getcmdtype() ~= ":" then return opening end
      local before, after = context()
      if escaped(before) then return opening end
      if opening == '"' then
        if after:sub(1, 1) == '"' then return "<Right>" end
        -- Finish an existing double-quoted string without adding another pair.
        local count = 0
        for pos = 1, #before do
          if before:sub(pos, pos) == '"' and not escaped(before:sub(1, pos - 1)) then count = count + 1 end
        end
        if count % 2 == 1 then return '"' end
      end
      return opening .. closing .. "<Left>"
    end, { expr = true, desc = "Command-line pair: " .. opening .. closing })
  end
  vim.keymap.set("c", ")", function()
    if vim.fn.getcmdtype() ~= ":" then return ")" end
    local before, after = context()
    return not escaped(before) and after:sub(1, 1) == ")" and "<Right>" or ")"
  end, { expr = true, desc = "Skip command-line closing parenthesis" })
  vim.keymap.set("c", "<BS>", function()
    if vim.fn.getcmdtype() ~= ":" then return "<BS>" end
    local before, after = context()
    local left, right = before:sub(-1), after:sub(1, 1)
    if not escaped(before:sub(1, -2)) and ((left == "(" and right == ")") or (left == '"' and right == '"')) then
      return "<BS><Del>"
    end
    return "<BS>"
  end, { expr = true, desc = "Delete empty command-line pair" })
end
return M
