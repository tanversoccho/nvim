vim.opt.cursorline = true

-- Make cursor line background black
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#000000" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#000000", fg = "#ffffff" })
vim.api.nvim_set_hl(0, "CursorLine", {
    underline = true,
    undercurl = false, -- or use true for curly underline
    sp = "#ff0000",    -- underline color (red for visibility)
})

