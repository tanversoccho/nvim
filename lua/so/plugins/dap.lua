-- One DAP client, built-in REPL/widgets; no DAP UI or completion plugin.
local dap = require("dap")
local win = vim.fn.has("win32") == 1
local packages = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages")
local function find(package, suffix)
  local root = vim.fs.joinpath(packages, package)
  local matches = vim.fn.globpath(root, "**/" .. suffix, false, true)
  for _, path in ipairs(matches) do
    if vim.uv.fs_stat(path) then return path end
  end
  error("Missing " .. package .. "/" .. suffix .. ". Run :MasonToolsInstall and restart.")
end
local function python()
  for _, folder in ipairs({ ".venv", "venv" }) do
    local path = vim.fs.joinpath(vim.fn.getcwd(), folder, win and "Scripts/python.exe" or "bin/python")
    if vim.fn.executable(path) == 1 then return path end
  end
  local path = vim.fn.exepath("python")
  if path == "" then error("Python is not on PATH; activate your project environment first.") end
  return path
end
-- Resolve paths at launch: Mason installation may still be running at startup.
dap.adapters.python = function(callback)
  callback({ type = "executable", command = find("debugpy", win and "Scripts/python.exe" or "bin/python"),
    args = { "-m", "debugpy.adapter" } })
end
dap.configurations.python = {
  { name = "Python: current file", type = "python", request = "launch", program = "${file}",
    cwd = "${workspaceFolder}", pythonPath = python, console = "integratedTerminal" },
}
dap.adapters.codelldb = function(callback)
  callback({ type = "server", port = "${port}", executable = {
    command = find("codelldb", win and "codelldb.exe" or "codelldb"),
    args = { "--port", "${port}" }, detached = not win,
  } })
end
dap.configurations.c = {
  { name = "C: launch compiled executable", type = "codelldb", request = "launch",
    program = function()
      return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
    end, cwd = "${workspaceFolder}", stopOnEntry = false },
}
dap.configurations.cpp = dap.configurations.c

dap.adapters["pwa-node"] = function(callback)
  callback({ type = "server", host = "127.0.0.1", port = "${port}", executable = {
    command = "node", args = { find("js-debug-adapter", "dapDebugServer.js"), "${port}", "127.0.0.1" },
  } })
end
for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
  dap.configurations[ft] = {
    { name = "Node: launch current JavaScript file", type = "pwa-node", request = "launch",
      program = "${file}", cwd = "${workspaceFolder}", sourceMaps = true,
      console = "integratedTerminal", skipFiles = { "<node_internals>/**" } },
    { name = "Node: attach to running process", type = "pwa-node", request = "attach",
      processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}", sourceMaps = true },
  }
end
-- Standalone Lua interpreter; this does not debug Neovim's embedded Lua runtime.
dap.adapters["local-lua"] = function(callback)
  callback({ type = "executable", command = "node",
    args = { find("local-lua-debugger-vscode", "extension/debugAdapter.js") } })
end
dap.configurations.lua = {
  { name = "Lua: current standalone file", type = "local-lua", request = "launch",
    cwd = "${workspaceFolder}",
    program = function()
      return { lua = vim.g.so_lua_executable or "lua", file = vim.api.nvim_buf_get_name(0) }
    end,
    extensionPath = function()
      return vim.fs.dirname(vim.fs.dirname(find("local-lua-debugger-vscode", "extension/debugAdapter.js")))
    end },
}
local map = vim.keymap.set
map("n", "<F5>", dap.continue, { desc = "Debug: start / continue" })
map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
map("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: breakpoint" })
map("n", "<leader>dr", dap.repl.open, { desc = "Debug: REPL" })
map("n", "<leader>dx", dap.terminate, { desc = "Debug: terminate" })
map("n", "<leader>dv", function() require("dap.ui.widgets").hover() end, { desc = "Debug: inspect value" })
