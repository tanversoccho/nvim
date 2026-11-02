-- Applies only to Lua buffers.

-- Filetype-specific settings take precedence over global defaults.
-- Use spaces, with two spaces per indentation level.
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2

-- Allow Neovim to undo these settings when the filetype changes.
local undo = "setlocal expandtab< shiftwidth< softtabstop< tabstop<"
vim.b.undo_ftplugin = vim.b.undo_ftplugin and (vim.b.undo_ftplugin .. " | " .. undo) or undo
