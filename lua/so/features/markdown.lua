-- Native, Markdown-only decorations. No renderer plugin or parser dependency.
local M = {}
local api = vim.api
local ns = api.nvim_create_namespace("so-markdown-preview")
local options = {
  enabled = true,
  debounce_ms = 60,
  max_lines = 20000,
  hide_cursor_line = true,
  code_blocks = true,
  code_labels = true,
  checkboxes = true,
  headings = true,
  inline_code = true,
  links = true,
}
local overrides, pending, tracked = {}, {}, {}
local function highlights()
  for level, link in ipairs({ "Title", "Function", "Type", "Identifier", "Statement", "Special" }) do
    api.nvim_set_hl(0, "SoMarkdownHeading" .. level, { default = true, link = link })
  end
  api.nvim_set_hl(0, "SoMarkdownCode", { default = true, link = "CursorLine" })
  api.nvim_set_hl(0, "SoMarkdownCodeLabel", { default = true, link = "Comment" })
  api.nvim_set_hl(0, "SoMarkdownInlineCode", { default = true, link = "String" })
  api.nvim_set_hl(0, "SoMarkdownLink", { default = true, link = "Underlined" })
  api.nvim_set_hl(0, "SoMarkdownChecked", { default = true, link = "DiagnosticOk" })
  api.nvim_set_hl(0, "SoMarkdownUnchecked", { default = true, link = "DiagnosticWarn" })
end
local function eligible(buf)
  return api.nvim_buf_is_valid(buf)
    and api.nvim_buf_is_loaded(buf)
    and vim.bo[buf].filetype == "markdown"
    and vim.bo[buf].buftype == ""
end
local function enabled(buf)
  if overrides[buf] ~= nil then
    return overrides[buf]
  end
  return options.enabled
end
local function escaped(text, col)
  local count = 0
  while col > 1 and text:sub(col - 1, col - 1) == "\\" do
    count = count + 1
    col = col - 1
  end
  return count % 2 == 1
end
local function mark(buf, row, first, last, group)
  if last > first then
    api.nvim_buf_set_extmark(buf, ns, row, first, {
      end_col = last,
      hl_group = group,
      priority = 120,
    })
  end
end
local function inline(buf, row, text)
  -- Track code spans so links inside them remain code, rather than links.
  local spans, start = {}, 1
  while start <= #text do
    local a, b = text:find("`+", start)
    if not a then
      break
    end
    local delimiter = text:sub(a, b)
    local c, d = text:find(delimiter, b + 1, true)
    while c and (text:sub(c - 1, c - 1) == "`" or text:sub(d + 1, d + 1) == "`") do
      c, d = text:find(delimiter, d + 1, true)
    end
    if c and not escaped(text, a) then
      spans[#spans + 1] = { a, d }
      if options.inline_code then
        mark(buf, row, a - 1, d, "SoMarkdownInlineCode")
      end
      start = d + 1
    else
      start = b + 1
    end
  end
  local function inside_code(a, b)
    for _, span in ipairs(spans) do
      if a <= span[2] and b >= span[1] then
        return true
      end
    end
    return false
  end
  if options.links then
    -- Intentionally small: same-line inline links, images, and autolinks.
    for _, pattern in ipairs({ "!?%[[^%]]+%]%b()", "<https?://[^>]+>" }) do
      local offset = 1
      while true do
        local a, b = text:find(pattern, offset)
        if not a then
          break
        end
        if not escaped(text, a) and not inside_code(a, b) then
          mark(buf, row, a - 1, b, "SoMarkdownLink")
        end
        offset = b + 1
      end
    end
  end
end
function M.render(buf)
  if not api.nvim_buf_is_valid(buf) or not api.nvim_buf_is_loaded(buf) then
    return
  end
  api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  if not eligible(buf) then
    tracked[buf] = nil
    return
  end
  tracked[buf] = true
  if not enabled(buf) then
    return
  end
  if api.nvim_buf_line_count(buf) > options.max_lines then
    return
  end
  local cursor = -1
  if options.hide_cursor_line and api.nvim_get_current_buf() == buf then
    cursor = api.nvim_win_get_cursor(0)[1] - 1
  end
  local fence, fence_size
  for index, text in ipairs(api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local row = index - 1
    local indent, run, info = text:match("^( *)([`~]+)(.*)$")
    local valid = run and #indent <= 3 and #run >= 3 and (run:match("^`+$") or run:match("^~+$"))
    local opening, closing = false, false
    if fence then
      closing = valid and run:sub(1, 1) == fence and #run >= fence_size and info:match("^%s*$")
    elseif valid and (run:sub(1, 1) ~= "`" or not info:find("`", 1, true)) then
      fence, fence_size = run:sub(1, 1), #run
      opening = true
    end
    if fence then
      if row ~= cursor then
        if options.code_blocks then
          api.nvim_buf_set_extmark(buf, ns, row, 0, {
            line_hl_group = "SoMarkdownCode",
            priority = 80,
          })
        end
        if opening and options.code_labels then
          local language = info:match("^%s*([^%s]+)") or "code"
          api.nvim_buf_set_extmark(buf, ns, row, 0, {
            virt_text = { { "  " .. language .. "  ", "SoMarkdownCodeLabel" } },
            virt_text_pos = "right_align",
            priority = 110,
          })
        end
      end
      if closing then
        fence, fence_size = nil, nil
      end
    elseif row ~= cursor then
      if options.headings then
        local hashes = text:match("^ ? ? ?(#+)%s+")
        if hashes and #hashes <= 6 then
          mark(buf, row, 0, #text, "SoMarkdownHeading" .. #hashes)
        end
      end
      if options.checkboxes then
        local first, last, checked = text:find("^%s*[-+*]%s+%[([ xX])%]")
        if not first then
          first, last, checked = text:find("^%s*%d+[.)]%s+%[([ xX])%]")
        end
        if first and (text:sub(last + 1, last + 1):match("%s") or last == #text) then
          local done = checked:lower() == "x"
          api.nvim_buf_set_extmark(buf, ns, row, last - 3, {
            virt_text = {
              { done and "☑  " or "☐  ", done and "SoMarkdownChecked" or "SoMarkdownUnchecked" },
            },
            virt_text_pos = "overlay",
            priority = 130,
          })
        end
      end
      -- Four-space/tab indented code is left to normal syntax highlighting.
      if not text:match("^    ") and not text:match("^\t") then
        inline(buf, row, text)
      end
    end
  end
end
local function queue(buf)
  if not api.nvim_buf_is_valid(buf) then
    return
  end
  local token = (pending[buf] or 0) + 1
  pending[buf] = token
  vim.defer_fn(function()
    if pending[buf] ~= token then
      return
    end
    pending[buf] = nil
    M.render(buf)
  end, options.debounce_ms)
end
function M.setup(config)
  options = vim.tbl_deep_extend("force", options, config or {})
  highlights()
  local group = api.nvim_create_augroup("so-markdown-preview", { clear = true })
  api.nvim_create_autocmd(
    {
      "FileType",
      "BufWinEnter",
      "TextChanged",
      "TextChangedI",
      "CursorMoved",
      "CursorMovedI",
      "InsertLeave",
    },
    {
      group = group,
      callback = function(args)
        if eligible(args.buf) or tracked[args.buf] then
          queue(args.buf)
        end
      end,
    }
  )
  api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      highlights()
      for _, buf in ipairs(api.nvim_list_bufs()) do
        if eligible(buf) then
          queue(buf)
        end
      end
    end,
  })
  api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args)
      overrides[args.buf], pending[args.buf], tracked[args.buf] = nil, nil, nil
    end,
  })
  api.nvim_create_user_command("SoPreviewToggle", function()
    local buf = api.nvim_get_current_buf()
    if not eligible(buf) then
      vim.notify("SoPreviewToggle is available in Markdown files only.", vim.log.levels.INFO)
      return
    end
    overrides[buf] = not enabled(buf)
    M.render(buf)
    vim.notify("Markdown decorations: " .. (enabled(buf) and "on" or "off"))
  end, { desc = "Toggle native Markdown decorations in this buffer", force = true })
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if eligible(buf) then
      queue(buf)
    end
  end
end
return M
