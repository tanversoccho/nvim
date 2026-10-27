-- Layout: | MODE  line:column  filename [+]       diagnostics  type  %  branch  time |
local config = {
  -- Standard groups supplied by Catppuccin or whichever colorscheme is active.
  highlights = {
    Filename = "Directory",
    Accent = "Special",
    Normal = "Statement",
    Insert = "String",
    Visual = "Special",
    Replace = "DiagnosticError",
    Command = "Function",
    Muted = "Comment",
    Branch = "Identifier",
    Type = "Type",
    Clock = "Number",
    Error = "DiagnosticError",
    Warn = "DiagnosticWarn",
    Info = "DiagnosticInfo",
    Hint = "DiagnosticHint",
  },
  icons = vim.g.have_nerd_font == true, -- Set false for a regular terminal font.
  global = true, -- One full-width bar, like the screenshot.
  clock = true,
  clock_format = "%H:%M", -- Use "%I:%M %p" for a 12-hour clock.
  branch = true, -- Requires only Git on PATH.
  diagnostics = true,
  git_refresh_ms = 3000, -- Rate-limit background Git processes.
  branch_max_chars = 24,
}

local api, uv = vim.api, vim.uv
-- Re-sourcing this file stops its old clock and invalidates pending callbacks.
if _G.SoStatusline and _G.SoStatusline.stop then
  _G.SoStatusline.stop()
end
local M = { alive = true }
_G.SoStatusline = M
local cache, jobs = {}, {}
local git_available = config.branch and vim.fn.executable("git") == 1
local function redraw()
  if M.alive then
    vim.cmd("redrawstatus")
  end
end
local function escape(value)
  -- Buffer and Git names must never be interpreted as statusline format codes.
  return tostring(value):gsub("[\r\n\t]", " "):gsub("%%", "%%%%")
end
local function short(value, max)
  if vim.fn.strchars(value) <= max then
    return value
  end
  return vim.fn.strcharpart(value, 0, math.max(1, max - 1)) .. "…"
end
local function window()
  local win = tonumber(vim.g.statusline_winid) or api.nvim_get_current_win()
  if not api.nvim_win_is_valid(win) then
    win = api.nvim_get_current_win()
  end
  return win, api.nvim_win_get_buf(win)
end
local function directory(buf)
  if vim.bo[buf].buftype ~= "" then
    return nil
  end
  local name = api.nvim_buf_get_name(buf)
  if name == "" or name:match("^%a+://") then
    return nil
  end
  local path = vim.fn.fnamemodify(name, ":p:h")
  return vim.fs.normalize(path)
end
local function refresh_git(buf, force)
  if not M.alive or not git_available or not api.nvim_buf_is_valid(buf) then
    return
  end
  local dir = directory(buf)
  if not dir or jobs[dir] then
    return
  end
  local now = uv.hrtime() / 1000000
  if not force and cache[dir] and now - cache[dir].time < config.git_refresh_ms then
    return
  end
  cache[dir] = cache[dir] or { branch = "", time = 0 }
  cache[dir].time = now
  jobs[dir] = true
  local function finish(value)
    vim.schedule(function()
      if not M.alive then
        return
      end
      cache[dir] = { branch = value, time = uv.hrtime() / 1000000 }
      jobs[dir] = nil
      redraw()
    end)
  end
  local function run(args, callback)
    local ok = pcall(vim.system, args, { text = true, timeout = 2000 }, callback)
    if not ok then
      finish("")
    end
  end
  run({ "git", "-C", dir, "rev-parse", "--abbrev-ref", "HEAD" }, function(result)
    if not M.alive then
      return
    end
    local branch = result.code == 0 and vim.trim(result.stdout or "") or ""
    if branch == "HEAD" then
      run({ "git", "-C", dir, "rev-parse", "--short", "HEAD" }, function(detached)
        finish(detached.code == 0 and ("@" .. vim.trim(detached.stdout or "")) or "")
      end)
    elseif branch == "" then
      -- symbolic-ref also handles a new repository before its first commit.
      run({ "git", "-C", dir, "symbolic-ref", "--quiet", "--short", "HEAD" }, function(unborn)
        finish(unborn.code == 0 and vim.trim(unborn.stdout or "") or "")
      end)
    else
      finish(branch)
    end
  end)
end
-- Read resolved theme highlights, preserving the theme's statusline background.
local function theme_group(name)
  local ok, value = pcall(api.nvim_get_hl, 0, { name = name, link = false, create = false })
  return ok and value or {}
end
local function highlights()
  local base = theme_group("StatusLine")
  local normal = theme_group("Normal")
  local base_fg, base_bg = base.fg or normal.fg, base.bg or normal.bg
  local base_ctermfg, base_ctermbg = base.ctermfg, base.ctermbg
  if base.reverse then
    base_fg, base_bg = base_bg, base_fg
    base_ctermfg, base_ctermbg = base_ctermbg, base_ctermfg
  end
  -- Only our own groups are defined. Never overwrite the colorscheme's groups.
  api.nvim_set_hl(0, "SoSLBase", { link = "StatusLine" })
  for section, source in pairs(config.highlights) do
    local source_hl = theme_group(source)
    local fg = source_hl.reverse and source_hl.bg or source_hl.fg
    local ctermfg = source_hl.reverse and source_hl.ctermbg or source_hl.ctermfg
    api.nvim_set_hl(0, "SoSL" .. section, {
      fg = fg or base_fg,
      bg = base_bg,
      ctermfg = ctermfg or base_ctermfg,
      ctermbg = base_ctermbg,
      bold = source_hl.bold,
      italic = source_hl.italic,
    })
  end
end
local function segment(group, text)
  return "%#SoSL" .. group .. "#" .. text .. "%#SoSLBase#"
end
local function mode()
  local name = api.nvim_get_mode().mode
  if name:sub(1, 1) == "i" then
    return "INSERT", "Insert"
  end
  if name == "v" then
    return "VISUAL", "Visual"
  end
  if name == "V" then
    return "V-LINE", "Visual"
  end
  if name == "\22" then
    return "V-BLOCK", "Visual"
  end
  if name == "s" or name == "S" or name == "\19" then
    return "SELECT", "Visual"
  end
  if name:sub(1, 1) == "R" then
    return "REPLACE", "Replace"
  end
  if name:sub(1, 1) == "c" or name == "r" or name == "rm" or name == "r?" then
    return "COMMAND", "Command"
  end
  if name:sub(1, 1) == "t" then
    return "TERMINAL", "Insert"
  end
  return "NORMAL", "Normal"
end
local icons = {
  lua = "",
  python = "",
  javascript = "",
  javascriptreact = "",
  typescript = "",
  typescriptreact = "",
  c = "",
  cpp = "",
  html = "",
  css = "",
  markdown = "",
  json = "",
  sql = "",
  typst = "T",
  vim = "",
  sh = "",
  ps1 = "",
}
function M.render()
  local win, buf = window()
  local width = config.global and vim.o.columns or api.nvim_win_get_width(win)
  local name, color = mode()
  local out = { segment("Accent", "▌"), segment(color, " " .. name .. " ") }
  if width >= 55 then
    out[#out + 1] = " %l:%v "
  end
  local path = api.nvim_buf_get_name(buf)
  local filename = path == "" and "[No Name]" or vim.fn.fnamemodify(path, ":t")
  if vim.bo[buf].buftype == "terminal" then
    filename = "[Terminal]"
  elseif vim.bo[buf].filetype == "netrw" then
    filename = "[Explorer]"
  end
  out[#out + 1] = "%<" .. segment("Filename", " " .. escape(filename))
  if vim.bo[buf].modified then
    out[#out + 1] = segment("Accent", " [+]")
  end
  if vim.bo[buf].readonly then
    out[#out + 1] = segment("Muted", " [RO]")
  end
  out[#out + 1] = " %="
  if config.diagnostics and width >= 80 then
    local counts = vim.diagnostic.count(buf)
    for _, item in ipairs({
      { 1, "Error", "E" },
      { 2, "Warn", "W" },
      { 3, "Info", "I" },
      { 4, "Hint", "H" },
    }) do
      local count = counts[item[1]] or 0
      if count > 0 then
        out[#out + 1] = segment(item[2], " " .. item[3] .. count)
      end
    end
    out[#out + 1] = " "
  end
  local ft = vim.bo[buf].filetype
  if width >= 70 and ft ~= "" then
    local icon = config.icons and icons[ft]
    out[#out + 1] = segment("Type", " " .. (icon and icon .. " " or "") .. escape(ft) .. " ")
  end
  if width >= 55 then
    out[#out + 1] = " %p%% "
  end
  local dir = directory(buf)
  local branch = dir and cache[dir] and cache[dir].branch or ""
  if width >= 100 and branch ~= "" then
    out[#out + 1] = segment(
      "Branch",
      " "
        .. (config.icons and " " or "git:")
        .. escape(short(branch, config.branch_max_chars))
        .. " "
    )
  end
  if config.clock and width >= 90 then
    out[#out + 1] = segment("Clock", " " .. os.date(config.clock_format) .. " ")
  end
  out[#out + 1] = segment("Accent", " ▐")
  return table.concat(out)
end
function M.stop()
  M.alive = false
  if M.timer and not M.timer:is_closing() then
    M.timer:stop()
    M.timer:close()
  end
end
highlights()
vim.opt.laststatus = config.global and 3 or 2
vim.opt.showmode = false
vim.opt.statusline = "%!v:lua.SoStatusline.render()"
local group = api.nvim_create_augroup("so-native-statusline", { clear = true })
api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FocusGained", "TermClose", "DirChanged" }, {
  group = group,
  callback = function()
    refresh_git(api.nvim_get_current_buf(), false)
    redraw()
  end,
})
api.nvim_create_autocmd(
  { "DiagnosticChanged", "ModeChanged", "BufModifiedSet", "WinEnter", "VimResized" },
  {
    group = group,
    callback = redraw,
  }
)
api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    highlights()
    redraw()
  end,
})
api.nvim_create_autocmd("VimLeavePre", { group = group, callback = M.stop })
api.nvim_create_user_command("SoStatuslineRefresh", function()
  refresh_git(api.nvim_get_current_buf(), true)
  redraw()
end, { force = true, desc = "Refresh native statusline and Git branch" })
if config.clock then
  M.timer = uv.new_timer()
  M.timer:start(1000, 30000, vim.schedule_wrap(redraw))
end
refresh_git(api.nvim_get_current_buf(), true)
-- Customization: edit the config table at the top; :source % reloads this file.
-- Git changes refresh on buffer/focus/write events or :SoStatuslineRefresh.
-- No LSP/linter dependency: diagnostics appear when any native provider reports them.
