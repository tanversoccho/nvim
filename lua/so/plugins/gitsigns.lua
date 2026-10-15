require("gitsigns").setup({
        signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
        },
}) -- }}}
vim.keymap.set('n', '<leader>ug', ':Gitsigns toggle_signs<CR>', { noremap = true, silent = true })
