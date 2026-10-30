-- Bootstrap lazy.nvim; original plugin list migrated from vim.pack.add().
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("lazy.nvim bootstrap failed: " .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { url = "https://github.com/mfussenegger/nvim-dap", lazy = false },
  { url = "https://github.com/folke/todo-comments.nvim", lazy = false },
  { url = "https://github.com/MunifTanjim/nui.nvim", lazy = false },
  { url = "https://github.com/kdheepak/lazygit.nvim", lazy = false },
  { url = "https://github.com/echasnovski/mini.nvim", lazy = false },
  { url = "https://github.com/tpope/vim-dadbod", lazy = false },
  { url = "https://github.com/kristijanhusak/vim-dadbod-ui", lazy = false },
  { url = "https://github.com/lewis6991/gitsigns.nvim", lazy = false },
  { url = "https://github.com/norcalli/nvim-colorizer.lua", lazy = false },
  { url = "https://github.com/nvim-tree/nvim-web-devicons", lazy = false },
  { url = "https://github.com/nvim-telescope/telescope.nvim", lazy = false },
  { url = "https://github.com/nvim-lua/plenary.nvim", lazy = false },
  { url = "https://github.com/nvim-treesitter/nvim-treesitter", lazy = false, branch = "main" },
  { url = "https://github.com/neovim/nvim-lspconfig", lazy = false },
  { url = "https://github.com/mason-org/mason.nvim", lazy = false },
  { url = "https://github.com/mason-org/mason-lspconfig.nvim", lazy = false },
  { url = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", lazy = false },
  { url = "https://github.com/chentoast/marks.nvim", lazy = false },
  { url = "https://github.com/mfussenegger/nvim-lint", lazy = false },
  { url = "https://github.com/folke/which-key.nvim", lazy = false },
}, {
  defaults = { lazy = false },
  install = { missing = true },
  checker = { enabled = false },
  change_detection = { notify = false },
})
