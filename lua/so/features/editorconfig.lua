local M = {}
local uv = vim.uv
local function template_path()
  return vim.fs.joinpath(vim.fn.stdpath("config"), "templates", "editorconfig.template")
end
local function edit(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end
function M.project_root()
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  local name = vim.api.nvim_buf_get_name(0)
  local start = cwd
  if vim.bo.buftype == "" and name ~= "" then
    name = vim.fs.normalize(name)
    local stat = uv.fs_stat(name)
    start = stat and stat.type == "directory" and name or vim.fs.dirname(name)
  end
  local root = vim.fs.root(start, { { ".git", ".hg" } })
    or vim.fs.root(
      start,
      { { "pyproject.toml", "package.json", "Cargo.toml", "go.mod", ".editorconfig" } }
    )
  if root then
    return root
  end
  local relative = vim.fs.relpath(cwd, start)
  if relative then
    return cwd
  end
  return start
end
function M.create(directory)
  local root = directory
      and directory ~= ""
      and vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(directory), ":p"))
    or M.project_root()
  local stat = uv.fs_stat(root)
  if not stat or stat.type ~= "directory" then
    vim.notify("Project directory does not exist: " .. root, vim.log.levels.ERROR)
    return
  end
  local target = vim.fs.joinpath(root, ".editorconfig")
  if uv.fs_lstat(target) then
    vim.notify("Existing .editorconfig preserved: " .. target)
    return
  end
  local source = template_path()
  local input, read_error = uv.fs_open(source, "r", 0)
  if not input then
    vim.notify("Cannot read template: " .. tostring(read_error), vim.log.levels.ERROR)
    return
  end
  local info = uv.fs_fstat(input)
  local data, err
  if info then
    data, err = uv.fs_read(input, info.size, 0)
  end
  uv.fs_close(input)
  if not data then
    vim.notify("Cannot read template contents: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  local output, write_error = uv.fs_open(target, "wx", 420)
  if not output then
    vim.notify("Cannot create .editorconfig: " .. tostring(write_error), vim.log.levels.ERROR)
    return
  end
  local offset = 0
  while offset < #data do
    local written
    written, write_error = uv.fs_write(output, data:sub(offset + 1), offset)
    if not written or written == 0 then
      break
    end
    offset = offset + written
  end
  uv.fs_close(output)
  if offset ~= #data then
    uv.fs_unlink(target)
    vim.notify("Could not copy template: " .. tostring(write_error), vim.log.levels.ERROR)
    return
  end
  vim.notify("Created " .. target .. ". Reopen source files to apply its indentation settings.")
end
function M.setup()
  vim.api.nvim_create_user_command("MakeEditorConfig", function(args)
    M.create(args.args)
  end, { nargs = "?", complete = "dir", desc = "Create project .editorconfig from your template" })
  vim.api.nvim_create_user_command("EditEditorConfigTemplate", function()
    edit(template_path())
  end, { desc = "Edit the master EditorConfig template" })
end
return M
