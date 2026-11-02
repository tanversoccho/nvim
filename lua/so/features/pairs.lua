local M = {}

-- ─────────────────────────────────────────────────────────────────────────
-- Command-line (':'-prompt) helpers
-- ─────────────────────────────────────────────────────────────────────────

-- Text before / after the cursor on the command line.
local function cmdline_context()
  local line, pos = vim.fn.getcmdline(), vim.fn.getcmdpos()
  return line:sub(1, pos - 1), line:sub(pos)
end

-- True when the last character of `before` is escaped by an odd number of '\'.
local function escaped(before)
  return #(before:match("(\\+)$") or "") % 2 == 1
end

-- ─────────────────────────────────────────────────────────────────────────
-- Insert-mode helpers
-- ─────────────────────────────────────────────────────────────────────────

-- Text before / after the cursor on the current buffer line.
local function buffer_surrounding()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-based
  return line:sub(1, col), line:sub(col + 1)
end

-- ─────────────────────────────────────────────────────────────────────────
-- Command-line mode: '(' and '"' auto-pairing
-- ─────────────────────────────────────────────────────────────────────────

local function setup_cmdline()
  for opening, closing in pairs({ ["("] = ")", ['"'] = '"' }) do
    vim.keymap.set("c", opening, function()
      if vim.fn.getcmdtype() ~= ":" then
        return opening
      end
      local before, after = cmdline_context()
      if escaped(before) then
        return opening
      end
      if opening == '"' then
        -- Already have a closing quote right after us → step over it.
        if after:sub(1, 1) == '"' then
          return "<Right>"
        end
        -- Finish an existing double-quoted string without adding another pair.
        local count = 0
        for pos = 1, #before do
          if before:sub(pos, pos) == '"' and not escaped(before:sub(1, pos - 1)) then
            count = count + 1
          end
        end
        if count % 2 == 1 then
          return '"'
        end
      end
      return opening .. closing .. "<Left>"
    end, { expr = true, desc = "Command-line pair: " .. opening .. closing })
  end

  -- Skip over an existing ')' (distinct key from its opener).
  vim.keymap.set("c", ")", function()
    if vim.fn.getcmdtype() ~= ":" then
      return ")"
    end
    local before, after = cmdline_context()
    return not escaped(before) and after:sub(1, 1) == ")" and "<Right>" or ")"
  end, { expr = true, desc = "Skip command-line closing parenthesis" })

  -- Delete both halves of an empty '()' / '""' pair in one keystroke.
  vim.keymap.set("c", "<BS>", function()
    if vim.fn.getcmdtype() ~= ":" then
      return "<BS>"
    end
    local before, after = cmdline_context()
    local left, right = before:sub(-1), after:sub(1, 1)
    if
      not escaped(before:sub(1, -2))
      and ((left == "(" and right == ")") or (left == '"' and right == '"'))
    then
      return "<BS><Del>"
    end
    return "<BS>"
  end, { expr = true, desc = "Delete empty command-line pair" })
end

-- ─────────────────────────────────────────────────────────────────────────
-- Insert mode: '(', '[', '{', '"' auto-pairing
-- ─────────────────────────────────────────────────────────────────────────

local function setup_insert()
  -- Same-key pairs ('"') are handled inside the opening map; distinct-key
  -- pairs ('()' '[]' '{}') get a dedicated closer-skip map below.
  local delimiters = { ['"'] = '"', ["("] = ")", ["["] = "]", ["{"] = "}" }

  for opening, closing in pairs(delimiters) do
    vim.keymap.set("i", opening, function()
      if vim.bo.buftype ~= "" then
        return opening
      end
      local before, after = buffer_surrounding()
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

  -- Skip over an existing closer for the distinct-key pairs.
  for _, closing in ipairs({ ")", "]", "}" }) do
    vim.keymap.set("i", closing, function()
      if vim.bo.buftype ~= "" then
        return closing
      end
      local _, after = buffer_surrounding()
      return after:sub(1, 1) == closing and "<Right>" or closing
    end, { expr = true, desc = "Skip matching closing delimiter" })
  end

  -- (Optional, ported from the command-line side) Delete both halves of an
  -- empty '()' / '[]' / '{}' / '""' pair with one <BS>.
  vim.keymap.set("i", "<BS>", function()
    if vim.bo.buftype ~= "" then
      return "<BS>"
    end
    local before, after = buffer_surrounding()
    local left, right = before:sub(-1), after:sub(1, 1)
    if escaped(before:sub(1, -2)) then
      return "<BS>"
    end
    if
      (left == "(" and right == ")")
      or (left == "[" and right == "]")
      or (left == "{" and right == "}")
      or (left == '"' and right == '"')
    then
      return "<BS><Del>"
    end
    return "<BS>"
  end, { expr = true, desc = "Delete empty insert-mode pair" })
end

-- ─────────────────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────────────────

M.setup_cmdline = setup_cmdline
M.setup_insert = setup_insert

function M.setup()
  setup_cmdline()
  setup_insert()
end

return M
