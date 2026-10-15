local function get_viewer()
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
        return 'sumatrapdf'
    else
        return 'zathura'
    end
end

vim.g.vimtex_view_method = get_viewer()

-- VimTeX Configuration
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_latexmk = {
    continuous = 1,           -- Enable continuous compilation (hot-reload)
    out_dir = 'build',        -- Put output files in build directory
    options = {
        '-pdf',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
    }
}
vim.g.vimtex_view_automatic = 1
vim.g.vimtex_quickfix_mode = 2  -- Show errors in quickfix window
-- Auto-open PDF on first compile
vim.g.vimtex_view_automatic = 1

-- Disable folding (optional)
vim.g.vimtex_fold_enabled = 0

-- Use biber for bibliography (if needed)
vim.g.vimtex_bibtex_latexmk = '-bibtex-'
