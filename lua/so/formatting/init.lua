local M = {}
local config = require("so.formatting.config")
local uv = vim.uv

local function rules(name)
  return vim.fs.joinpath(vim.fn.stdpath("config"), "templates", "formatting", name)
end
local function file_exists(path)
  local stat = path and uv.fs_stat(path)
  return stat and stat.type == "file"
end
local function executable(name)
  local path = vim.fn.exepath(name)
  if path == "" then
    error("Missing " .. name .. ". Run :SoFormatToolsInstall, wait, and restart Neovim.", 0)
  end
  if path:lower():match("%.cmd$") or path:lower():match("%.bat$") then
    local package = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", name)
    local candidates = {
      vim.fs.joinpath(package, name .. ".exe"),
      vim.fs.joinpath(package, "venv", "Scripts", name .. ".exe"),
    }
    vim.list_extend(candidates, vim.fn.globpath(package, "**/" .. name .. ".exe", false, true))
    for _, candidate in ipairs(candidates) do
      if file_exists(candidate) then
        return candidate
      end
    end
    error(
      "Cannot directly execute "
        .. path
        .. ". Install "
        .. name
        .. " through Mason so its native .exe is available.",
      0
    )
  end
  return path
end
local function prettier_command(filename)
  local candidates = {}
  if config.prettier_cli then
    table.insert(candidates, config.prettier_cli)
  end
  local dir = vim.fs.dirname(filename)
  while dir do
    table.insert(
      candidates,
      vim.fs.joinpath(dir, "node_modules", "prettier", "bin", "prettier.cjs")
    )
    local parent = vim.fs.dirname(dir)
    if parent == dir then
      break
    end
    dir = parent
  end
  local mason = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "prettier")
  table.insert(
    candidates,
    vim.fs.joinpath(mason, "node_modules", "prettier", "bin", "prettier.cjs")
  )
  -- Also recognize a globally installed npm Prettier beside its command shim.
  local shim = vim.fn.exepath("prettier")
  if shim ~= "" then
    local bin = vim.fs.dirname(shim)
    table.insert(
      candidates,
      vim.fs.joinpath(bin, "node_modules", "prettier", "bin", "prettier.cjs")
    )
    table.insert(
      candidates,
      vim.fs.joinpath(bin, "..", "lib", "node_modules", "prettier", "bin", "prettier.cjs")
    )
  end
  for _, path in ipairs(candidates) do
    if file_exists(path) then
      return { executable("node"), path }
    end
  end
  -- Unix executable scripts can run directly. Windows .cmd shims cannot be
  -- spawned directly by vim.system; use Node with the JS entrypoint above.
  if shim ~= "" and not shim:lower():match("%.cmd$") and not shim:lower():match("%.bat$") then
    return { shim }
  end
  error(
    "Cannot find Prettier's JavaScript entrypoint. Install it through Mason or set prettier_cli in so/formatting/config.lua.",
    0
  )
end


-- Run Java directly: Mason's Windows .cmd launcher cannot be spawned by vim.system.
local function ktfmt_command(filename)
  local options = config.ktfmt or {}
  local jar = options.jar
  if jar then
    if not file_exists(jar) then error("ktfmt.jar does not exist: " .. jar, 0) end
  else
    local root = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "ktfmt")
    local candidates = {}
    for _, path in ipairs(vim.fn.globpath(root, "**/*.jar", false, true)) do
      local name = vim.fs.basename(path):lower()
      if file_exists(path) and (name == "ktfmt.jar" or name:match("^ktfmt.*with%-dependencies%.jar$")) then
        candidates[#candidates + 1] = path
      end
    end
    if #candidates ~= 1 then
      error("Cannot identify Mason's ktfmt JAR. Run :MasonInstall ktfmt, or set ktfmt.jar in so/formatting/config.lua.", 0)
    end
    jar = candidates[1]
  end
  local java = options.java
  if not java and vim.env.JAVA_HOME and vim.env.JAVA_HOME ~= "" then
    local name = vim.fn.has("win32") == 1 and "java.exe" or "java"
    local candidate = vim.fs.joinpath(vim.env.JAVA_HOME, "bin", name)
    if file_exists(candidate) then java = candidate end
  end
  java = java or vim.fn.exepath("java")
  if java == "" then error("Java not found. Install a JDK or set ktfmt.java to java.exe, then restart Neovim.", 0) end
  local style = options.style or "kotlinlang"
  if style ~= "kotlinlang" and style ~= "google" then
    error('ktfmt.style must be "kotlinlang" or "google".', 0)
  end
  local cmd = { java, "-Dfile.encoding=UTF-8", "-jar", jar, "--" .. style .. "-style" }
  if config.use_project_config then table.insert(cmd, "--enable-editorconfig") end
  -- stdin preserves unsaved edits; the filename also identifies Kotlin scripts.
  vim.list_extend(cmd, { "--stdin-name=" .. filename, "-" })
  return cmd
end

function M.command(buf)
  local kind = config.formatters[vim.bo[buf].filetype]
  if not kind then
    error("No formatter configured for " .. vim.bo[buf].filetype, 0)
  end
  local filename = vim.api.nvim_buf_get_name(buf)
  if filename == "" then
    error("Save/name the file first so its parser and rules can be resolved.", 0)
  end
  local cmd
  if kind == "prettier" then
    cmd = prettier_command(filename)
    vim.list_extend(cmd, { "--stdin-filepath", filename })
    if not config.use_project_config then
      vim.list_extend(cmd, { "--config", rules("prettier.json"), "--no-editorconfig" })
    end
  elseif kind == "ktfmt" then
    cmd = ktfmt_command(filename)
  elseif kind == "ruff" then
    cmd = { executable("ruff"), "format", "--stdin-filename", filename }
    if not config.use_project_config then
      vim.list_extend(cmd, { "--config", rules("ruff.toml") })
    end
    table.insert(cmd, "-")
  elseif kind == "stylua" then
    cmd = { executable("stylua"), "--stdin-filepath", filename }
    if not config.use_project_config then
      vim.list_extend(cmd, { "--config-path", rules("stylua.toml") })
    end
    table.insert(cmd, "-")
  elseif kind == "clang-format" then
    cmd = { executable("clang-format"), "--assume-filename=" .. filename }
    if not config.use_project_config then
      table.insert(cmd, "--style=file:" .. rules("clang-format.yaml"))
    end
  elseif kind == "typstyle" then
    cmd = { executable("typstyle") }
    if not config.use_project_config then
      vim.list_extend(cmd, { "--indent-width", tostring(config.typstyle.indent_width),
        "--line-width", tostring(config.typstyle.line_width) })
    end
  else
    error("Unknown formatter: " .. tostring(kind), 0)
  end
  local timeout_ms = kind == "ktfmt" and (config.ktfmt or {}).timeout_ms or nil
  return cmd, filename, timeout_ms or config.timeout_ms
end

function M.format(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local ok, err = pcall(function()
    if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then
      error("Buffer is not an editable source file.", 0)
    end
    local cmd, filename, timeout_ms = M.command(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local input = table.concat(lines, "\n") .. (vim.bo[buf].endofline and "\n" or "")
    local result = vim
      .system(cmd, {
        stdin = input,
        text = true,
        cwd = vim.fs.dirname(filename),
      })
      :wait(timeout_ms)
    if result.code ~= 0 then
      error(
        (result.stderr and result.stderr ~= "" and result.stderr)
          or ("Formatter failed with exit code " .. tostring(result.code)),
        0
      )
    end
    local output = result.stdout or ""
    if output == input then
      return
    end
    if output == "" and input:find("%S") then
      error("Formatter returned empty output; buffer preserved.", 0)
    end
    local formatted = vim.split(output, "\n", { plain = true })
    if output:sub(-1) == "\n" then
      table.remove(formatted)
    end
    if #formatted == 0 then
      formatted = { "" }
    end
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
    vim.bo[buf].endofline = output:sub(-1) == "\n"
    vim.fn.winrestview(view)
  end)
  if not ok then
    vim.notify("Format: " .. tostring(err), vim.log.levels.ERROR)
  end
  return ok
end

function M.formatexpr()
  -- Never run the whole-file formatter during automatic text wrapping in Insert.
  if vim.v.char ~= "" then
    return 0
  end
  M.format(vim.api.nvim_get_current_buf())
  -- Return success even on tool failure to suppress Vim's text-wrapping fallback.
  return 0
end
local function configure(buf)
  if vim.bo[buf].buftype ~= "" or not config.formatters[vim.bo[buf].filetype] then
    return
  end
  vim.bo[buf].formatexpr = "v:lua.require'so.formatting'.formatexpr()"
  vim.bo[buf].formatprg = ""
  vim.keymap.set("n", "<leader>cf", function()
    M.format(buf)
  end, { buffer = buf, desc = "Format file using your formatter rules" })
end

function M.setup()
  vim.api.nvim_create_autocmd({ "FileType", "LspAttach", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("so-unified-formatting", { clear = true }),
    callback = function(args)
      configure(args.buf)
    end,
  })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    configure(buf)
  end
  vim.api.nvim_create_user_command("SoFormat", function()
    M.format()
  end, { desc = "Format whole source file using your Neovim rules" })
  vim.api.nvim_create_user_command("SoFormatInfo", function()
    local ok, cmd = pcall(M.command, vim.api.nvim_get_current_buf())
    if ok then
      vim.notify(vim.inspect(cmd))
    else
      vim.notify(tostring(cmd), vim.log.levels.WARN)
    end
  end, { desc = "Show the selected formatter and exact arguments" })
  vim.api.nvim_create_user_command("SoFormatToolsInstall", function()
    vim.cmd("MasonInstall " .. table.concat(config.install, " "))
  end, { desc = "Install configured formatters through Mason" })
  vim.api.nvim_create_user_command("SoFormatToolsClean", function()
    local registry = require("mason-registry")
    local remove = {}
    for _, name in ipairs(config.retire) do
      if registry.has_package(name) and registry.get_package(name):is_installed() then
        table.insert(remove, name)
      end
    end
    if #remove == 0 then
      vim.notify("No retired formatter/lint packages remain.")
      return
    end
    vim.notify("Removing Mason packages: " .. table.concat(remove, ", "))
    vim.cmd("MasonUninstall " .. table.concat(remove, " "))
  end, { desc = "Remove only packages listed in formatting/config.lua retire" })
end
return M
