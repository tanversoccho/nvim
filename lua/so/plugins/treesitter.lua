-- nvim-treesitter main branch (Neovim 0.12).
local install_dir = vim.fs.normalize(vim.fn.stdpath("data") .. "/site")

-- Add the exact normalized path, including on Windows.
vim.opt.runtimepath:prepend(install_dir)

require("nvim-treesitter").setup({
  install_dir = install_dir,
})

-- Enable highlighting when a parser and highlight query are available.
-- Install parsers manually with :TSInstall; no downloads on startup.
local group = vim.api.nvim_create_augroup("so-treesitter", {
  clear = true,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Enable Treesitter highlighting for available languages",
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(filetype)

    if not lang then
      return
    end

    local ok, query = pcall(vim.treesitter.query.get, lang, "highlights")
    if not ok or not query then
      return
    end

    pcall(vim.treesitter.start, args.buf, lang)
  end,
})
