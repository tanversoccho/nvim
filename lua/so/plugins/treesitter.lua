-- nvim-treesitter main branch (Neovim 0.12).
local install_dir = vim.fn.stdpath("data") .. "/site"
-- Ensure the exact install path is present, including on Windows.
local present = false
for _, path in ipairs(vim.opt.runtimepath:get()) do
  if vim.fs.normalize(path) == vim.fs.normalize(install_dir) then
    present = true
    break
  end
end
if not present then
  vim.opt.runtimepath:prepend(install_dir)
end
require("nvim-treesitter").setup({ install_dir = install_dir })

-- Enable highlighting only when a parser and highlight query are available.
-- Install parsers explicitly with :TSInstall; no downloads on startup.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("so-treesitter", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if not lang then return end
    local ok, query = pcall(vim.treesitter.query.get, lang, "highlights")
    if ok and query then
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})
