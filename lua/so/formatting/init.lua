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
    "Cannot find Prettier's JavaScript entrypoint. "
      .. "Install it through Mason or set prettier_cli in so/formatting/config.lua.",
    0
  )
end

-- Run Java directly: Mason's Windows .cmd launcher cannot be spawned by vim.system.
local function ktfmt_command(filename, indent)
  local options = config.ktfmt or {}
  local jar = options.jar
  if jar then
    if not file_exists(jar) then
      error("ktfmt.jar does not exist: " .. jar, 0)
    end
  else
    local root = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "ktfmt")
    local candidates = {}
    for _, path in ipairs(vim.fn.globpath(root, "**/*.jar", false, true)) do
      local name = vim.fs.basename(path):lower()
      if
        file_exists(path)
        and (name == "ktfmt.jar" or name:match("^ktfmt.*with%-dependencies%.jar$"))
      then
        candidates[#candidates + 1] = path
      end
    end
    if #candidates ~= 1 then
      error(
        "Cannot identify Mason's ktfmt JAR. Run :MasonInstall ktfmt, or set ktfmt.jar in so/formatting/config.lua.",
        0
      )
    end
    jar = candidates[1]
  end
  local java = options.java
  if not java and vim.env.JAVA_HOME and vim.env.JAVA_HOME ~= "" then
    local name = vim.fn.has("win32") == 1 and "java.exe" or "java"
    local candidate = vim.fs.joinpath(vim.env.JAVA_HOME, "bin", name)
    if file_exists(candidate) then
      java = candidate
    end
  end
  java = java or vim.fn.exepath("java")
  if java == "" then
    error("Java not found. Install a JDK or set ktfmt.java to java.exe, then restart Neovim.", 0)
  end
  if not indent.spaces or (indent.width ~= 2 and indent.width ~= 4) then
    error(
      "ktfmt requires expandtab and shiftwidth=2 (Google) or 4 (Kotlinlang). Buffer preserved.",
      0
    )
  end
  local style = indent.width == 2 and "google" or "kotlinlang"
  local cmd = { java, "-Dfile.encoding=UTF-8", "-jar", jar, "--" .. style .. "-style" }
  -- stdin preserves unsaved edits; the filename also identifies Kotlin scripts.
  vim.list_extend(cmd, { "--stdin-name=" .. filename, "-" })
  return cmd
end

-- Read effective buffer options; never source ftplugin files manually.
-- Later :setlocal or EditorConfig changes are respected as well.
local function indentation(buf)
  local width = vim.bo[buf].shiftwidth
  if width == 0 then
    width = vim.bo[buf].tabstop
  end
  return {
    width = math.max(1, width),
    tabstop = vim.bo[buf].tabstop,
    spaces = vim.bo[buf].expandtab,
  }
end

local function read_json(path)
  local fd, err = io.open(path, "rb")
  if not fd then
    error("Cannot read formatter rules: " .. tostring(err), 0)
  end
  local contents = fd:read("*a")
  fd:close()
  local decoded = vim.json.decode(contents)
  if type(decoded) ~= "table" then
    error("Expected a JSON object in " .. path, 0)
  end
  return decoded
end

-- Resolve the existing C/C++ style first, then override just indentation.
local function clang_command(filename, indent, buf)
  local bin = executable("clang-format")
  local style = config.use_project_config and "file" or ("file:" .. rules("clang-format.yaml"))
  local result = vim
    .system({ bin, "--assume-filename=" .. filename, "--style=" .. style, "--dump-config" }, {
      text = true,
      cwd = vim.fs.dirname(filename),
    })
    :wait(config.timeout_ms)
  if result.code ~= 0 or not result.stdout or result.stdout == "" then
    error(
      (result.stderr and result.stderr ~= "" and result.stderr)
        or "Cannot resolve clang-format style.",
      0
    )
  end
  local yaml = result.stdout
  local values = {
    IndentWidth = tostring(indent.width),
    TabWidth = tostring(indent.tabstop),
    UseTab = indent.spaces and "Never" or "ForIndentation",
  }
  for key, value in pairs(values or {}) do
    if key ~= nil and value ~= nil then
      local count
      yaml, count = (yaml or ""):gsub(
        "([\r\n])" .. tostring(key) .. ":[^\r\n]*",
        "%1" .. tostring(key) .. ": " .. tostring(value)
      )
      if count == 0 then
        error("clang-format did not report " .. tostring(key), 0)
      end
    end
  end
  -- clang-format accepts a YAML file here, not a block-style YAML argument.
  local cache = vim.fs.joinpath(vim.fn.stdpath("cache"), "so-format-clang")
  vim.fn.mkdir(cache, "p")
  local path = vim.fs.joinpath(cache, tostring(vim.fn.getpid()) .. "-" .. buf .. ".yaml")
  local fd, err = io.open(path, "wb")
  if not fd then
    error("Cannot write resolved clang-format rules: " .. tostring(err), 0)
  end
  local written, write_err = fd:write(yaml)
  fd:close()
  if not written then
    error("Cannot write clang-format rules: " .. tostring(write_err), 0)
  end
  return { bin, "--assume-filename=" .. filename, "--style=file:" .. path }
end

function M.command(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local indent = indentation(buf)
  local kind = config.formatters[vim.bo[buf].filetype]
  if not kind then
    error("No formatter configured for " .. vim.bo[buf].filetype, 0)
  end
  local filename = vim.api.nvim_buf_get_name(buf)
  if filename == "" then
    error("Save/name the file first so its parser and rules can be resolved.", 0)
  end
  if not indent.spaces and indent.width ~= indent.tabstop then
    error("For tab indentation, set shiftwidth equal to tabstop. Buffer preserved.", 0)
  end
  local cmd, cwd
  if kind == "prettier" then
    cmd = prettier_command(filename)
    vim.list_extend(cmd, { "--stdin-filepath", filename })
    if not config.use_project_config then
      vim.list_extend(cmd, { "--config", rules("prettier.json"), "--no-editorconfig" })
    end
    vim.list_extend(cmd, {
      "--tab-width",
      tostring(indent.width),
      indent.spaces and "--no-use-tabs" or "--use-tabs",
    })
  elseif kind == "ktfmt" then
    cmd = ktfmt_command(filename, indent)
  elseif kind == "ruff" then
    cmd = { executable("ruff"), "format", "--stdin-filename", filename }
    if not config.use_project_config then
      vim.list_extend(cmd, { "--config", rules("ruff.toml") })
    end
    vim.list_extend(cmd, {
      "--config",
      "indent-width=" .. indent.width,
      "--config",
      'format.indent-style="' .. (indent.spaces and "space" or "tab") .. '"',
      "-",
    })
  elseif kind == "stylua" then
    cmd = { executable("stylua"), "--stdin-filepath", filename }
    if not config.use_project_config then
      vim.list_extend(cmd, { "--config-path", rules("stylua.toml") })
    end
    vim.list_extend(cmd, {
      "--indent-type",
      indent.spaces and "Spaces" or "Tabs",
      "--indent-width",
      tostring(indent.spaces and indent.width or indent.tabstop),
      "-",
    })
  elseif kind == "clang-format" then
    cmd = clang_command(filename, indent, buf)
  elseif kind == "beautysh" then
    -- Beautysh has --tab but no --no-tab. Isolate its cwd so a project's
    -- pyproject.toml cannot silently override expandtab with tab=true.
    cwd = vim.fs.joinpath(vim.fn.stdpath("cache"), "so-format-beautysh")
    vim.fn.mkdir(cwd, "p")
    cmd = { executable("beautysh"), "--indent-size", tostring(indent.width) }
    if not indent.spaces then
      table.insert(cmd, "--tab")
    end
    table.insert(cmd, "-")
  elseif kind == "xmlformatter" then
    -- Mason's package name differs from its executable name.
    local mason_exe = vim.fs.joinpath(
      vim.fn.stdpath("data"),
      "mason",
      "packages",
      "xmlformatter",
      "venv",
      "Scripts",
      "xmlformat.exe"
    )
    local bin = file_exists(mason_exe) and mason_exe or executable("xmlformat")
    cmd = {
      bin,
      "--indent",
      tostring(indent.spaces and indent.width or 1),
      "--indent-char",
      indent.spaces and " " or "\t",
      "--encoding",
      "UTF-8",
      "--outencoding",
      "UTF-8",
      "-",
    }
  elseif kind == "sql-formatter" then
    -- Run Node directly to avoid Windows .cmd shims.
    local cli = vim.fs.joinpath(
      vim.fn.stdpath("data"),
      "mason",
      "packages",
      "sql-formatter",
      "node_modules",
      "sql-formatter",
      "bin",
      "sql-formatter-cli.cjs"
    )
    if not file_exists(cli) then
      error("Cannot find SQL Formatter. Run :MasonInstall sql-formatter", 0)
    end
    local opts = {}
    if not config.use_project_config then
      opts = read_json(rules("sql-formatter.json"))
    else
      -- Match SQL Formatter's upward .sql-formatter.json discovery.
      local dir = vim.fs.dirname(filename)
      while dir do
        local path = vim.fs.joinpath(dir, ".sql-formatter.json")
        if file_exists(path) then
          opts = read_json(path)
          break
        end
        local parent = vim.fs.dirname(dir)
        if parent == dir then
          break
        end
        dir = parent
      end
    end
    opts.tabWidth, opts.useTabs = indent.width, not indent.spaces
    cmd = { executable("node"), cli, "--config", vim.json.encode(opts) }
  elseif kind == "typstyle" then
    if not indent.spaces then
      error("typstyle only supports space indentation. Enable expandtab for Typst.", 0)
    end
    cmd = { executable("typstyle"), "--indent-width", tostring(indent.width) }
    if not config.use_project_config then
      vim.list_extend(cmd, {
        "--line-width",
        tostring(config.typstyle.line_width),
      })
    end
  else
    error("Unknown formatter: " .. tostring(kind), 0)
  end
  local timeout_ms = kind == "ktfmt" and (config.ktfmt or {}).timeout_ms or nil
  return cmd, filename, timeout_ms or config.timeout_ms, cwd
end

function M.format(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local ok, err = pcall(function()
    if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then
      error("Buffer is not an editable source file.", 0)
    end
    local cmd, filename, timeout_ms, cwd = M.command(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local input = table.concat(lines, "\n") .. (vim.bo[buf].endofline and "\n" or "")
    local result = vim
      .system(cmd, {
        stdin = input,
        text = true,
        cwd = cwd or vim.fs.dirname(filename),
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
  -- Do not hijack gq: it should format the selected text, not the entire file.
  -- :SoFormat / <leader>cf remain the intentional whole-file commands.
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
      local indent = indentation(vim.api.nvim_get_current_buf())
      vim.notify(
        ("Indentation: shiftwidth=%d, tabstop=%d, %s\n%s"):format(
          indent.width,
          indent.tabstop,
          indent.spaces and "spaces" or "tabs",
          vim.inspect(cmd)
        )
      )
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
