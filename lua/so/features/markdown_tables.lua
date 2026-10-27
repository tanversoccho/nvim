local M = {}
local api = vim.api
local settings = { auto_align = true, max_lines = 20000 }
local function cells(line)
  local indent, text = line:match("^( *)(.*)$")
  if #indent > 3 or text == "" then
    return
  end
  local result, part, code, pipes = {}, "", nil, 0
  local i = 1
  while i <= #text do
    local c = text:sub(i, i)
    if c == "\\" and i < #text then
      part = part .. text:sub(i, i + 1)
      i = i + 2
    elseif c == "`" then
      local run = text:match("^(`+)", i)
      if not code then
        code = #run
      elseif code == #run then
        code = nil
      end
      part = part .. run
      i = i + #run
    elseif c == "|" and not code then
      result[#result + 1] = part
      part = ""
      pipes = pipes + 1
      i = i + 1
    else
      part = part .. c
      i = i + 1
    end
  end
  result[#result + 1] = part
  if pipes == 0 then
    return
  end
  if text:sub(1, 1) == "|" then
    table.remove(result, 1)
  end
  -- A trailing delimiter generated an empty last field.
  if result[#result] and result[#result]:match("^%s*$") and text:match("|%s*$") then
    table.remove(result)
  end
  if #result == 0 then
    return
  end
  for n, value in ipairs(result) do
    result[n] = value:match("^%s*(.-)%s*$")
  end
  return result, indent
end
local function separator(row)
  if not row then
    return false
  end
  for _, value in ipairs(row) do
    if not value:match("^:?[%-][%-][%-]+:?$") then
      return false
    end
  end
  return true
end
function M.align(buf)
  buf = buf or api.nvim_get_current_buf()
  if not api.nvim_buf_is_valid(buf) or not api.nvim_buf_is_loaded(buf) then
    return false
  end
  if
    vim.bo[buf].filetype ~= "markdown"
    or vim.bo[buf].buftype ~= ""
    or not vim.bo[buf].modifiable
  then
    return false
  end
  if api.nvim_buf_line_count(buf) > settings.max_lines then
    return false
  end
  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
  local replacements, i, fence, fence_size = {}, 1, nil, nil
  while i <= #lines do
    local prefix, run, tail = lines[i]:match("^( *)([`~]+)(.*)$")
    local valid = run and #prefix <= 3 and #run >= 3 and (run:match("^`+$") or run:match("^~+$"))
    if fence then
      if valid and run:sub(1, 1) == fence and #run >= fence_size and tail:match("^%s*$") then
        fence, fence_size = nil, nil
      end
      i = i + 1
    elseif valid and (run:sub(1, 1) ~= "`" or not tail:find("`", 1, true)) then
      fence, fence_size = run:sub(1, 1), #run
      i = i + 1
    else
      local header, indent = cells(lines[i])
      local divider, divider_indent = cells(lines[i + 1] or "")
      if
        header
        and divider
        and #header == #divider
        and indent == divider_indent
        and separator(divider)
      then
        local rows, last = { header, divider }, i + 1
        while last + 1 <= #lines do
          local row, row_indent = cells(lines[last + 1])
          -- Leave irregular tables untouched beyond the valid rectangular portion.
          if not row or #row ~= #header or row_indent ~= indent then
            break
          end
          rows[#rows + 1] = row
          last = last + 1
        end
        local widths = {}
        for col = 1, #header do
          widths[col] = 3
            + (divider[col]:sub(1, 1) == ":" and 1 or 0)
            + (divider[col]:sub(-1) == ":" and 1 or 0)
          for r, row in ipairs(rows) do
            if r ~= 2 then
              widths[col] = math.max(widths[col], vim.fn.strdisplaywidth(row[col]))
            end
          end
        end
        local formatted = {}
        for r, row in ipairs(rows) do
          local out = {}
          for col, value in ipairs(row) do
            if r == 2 then
              local left = value:sub(1, 1) == ":" and ":" or ""
              local right = value:sub(-1) == ":" and ":" or ""
              -- Keep at least three hyphens even with alignment colons.
              out[col] = left .. string.rep("-", math.max(3, widths[col] - #left - #right)) .. right
            else
              out[col] = value .. string.rep(" ", widths[col] - vim.fn.strdisplaywidth(value))
            end
          end
          formatted[r] = indent .. "| " .. table.concat(out, " | ") .. " |"
        end
        local changed = false
        for r, text in ipairs(formatted) do
          if text ~= lines[i + r - 1] then
            changed = true
            break
          end
        end
        if changed then
          replacements[#replacements + 1] = { first = i - 1, last = last, lines = formatted }
        end
        i = last + 1
      else
        i = i + 1
      end
    end
  end
  if #replacements == 0 then
    return false
  end
  local view = api.nvim_get_current_buf() == buf and vim.fn.winsaveview() or nil
  for n = #replacements, 1, -1 do
    if n < #replacements then
      api.nvim_buf_call(buf, function()
        vim.cmd("undojoin")
      end)
    end
    local change = replacements[n]
    api.nvim_buf_set_lines(buf, change.first, change.last, false, change.lines)
  end
  if view then
    vim.fn.winrestview(view)
  end
  -- Refresh the optional renderer after source edits.
  local renderer = package.loaded["so.features.markdown"]
  if renderer then
    renderer.render(buf)
  end
  return true
end
function M.setup(config)
  settings = vim.tbl_deep_extend("force", settings, config or {})
  api.nvim_create_user_command("SoMarkdownTableAlign", function()
    M.align()
  end, {
    desc = "Align Markdown tables",
    force = true,
  })
  api.nvim_create_autocmd({ "InsertLeave", "BufWritePre" }, {
    group = api.nvim_create_augroup("so-markdown-tables", { clear = true }),
    callback = function(args)
      if settings.auto_align then
        M.align(args.buf)
      end
    end,
  })
end
return M
