-- Never treat an unprefixed Windows drive letter as a database adapter.
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_win_position = "left"
vim.g.db_ui_winwidth = 35
vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod/queries"

local function open_sqlite(filename)
  if vim.fn.executable("sqlite3") ~= 1 then
    vim.notify("Install sqlite3 and restart Neovim (Scoop: scoop install sqlite).", vim.log.levels.ERROR)
    return
  end
  local path = vim.fs.normalize(vim.fn.fnamemodify(filename, ":p"))
  local stat = vim.uv.fs_stat(path)
  if not stat or stat.type ~= "file" then
    vim.notify("SQLite file does not exist: " .. path, vim.log.levels.ERROR)
    return
  end
  -- Encode URL-significant characters, retaining the drive colon and slashes.
  local encoded = path:gsub("([^%w%-%._~/:])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  local url = "sqlite:" .. encoded
  local connections = vim.g.dbs or {}
  connections[path] = url
  vim.g.dbs = connections
  vim.g.db = url
  vim.cmd("DBUI")
end
vim.api.nvim_create_user_command("SoSqlite", function(args)
  local path = args.args
  if path == "" then path = vim.api.nvim_buf_get_name(0) end
  if path == "" or path:match("^%a+://") then
    vim.notify("Use :SoSqlite path/to/database.sqlite3", vim.log.levels.WARN)
    return
  end
  open_sqlite(path)
end, { nargs = "?", complete = "file", desc = "Open an existing SQLite file in Dadbod UI" })
vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<CR>", { desc = "Database explorer" })
