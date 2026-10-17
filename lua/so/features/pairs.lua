local M = {}
local function surrounding()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return line:sub(1, col), line:sub(col + 1)
end

function M.setup()
  local delimiters = { ['"'] = '"', ["("] = ")", ["["] = "]", ["{"] = "}" }
  for opening, closing in pairs(delimiters) do
    vim.keymap.set("i", opening, function()
      if vim.bo.buftype ~= "" then
        return opening
      end
      local before, after = surrounding()
      if opening == '"' then
        local slashes = before:match("(\\+)$") or ""
        if #slashes % 2 == 1 then
          return opening
        end
        if after:sub(1, 1) == closing then
          return "<Right>"
        end
      end
      return opening .. closing .. "<Left>"
    end, { expr = true, desc = "Native pair: " .. opening .. closing })
  end
  for _, closing in ipairs({ ")", "]", "}" }) do
    vim.keymap.set("i", closing, function()
      if vim.bo.buftype ~= "" then
        return closing
      end
      local _, after = surrounding()
      return after:sub(1, 1) == closing and "<Right>" or closing
    end, { expr = true, desc = "Skip matching closing delimiter" })
  end
end
return M
